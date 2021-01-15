#!/bin/bash

set -euxo pipefail

SOURCE_ZIP_FILE=timestamp-app.zip
SOURCE_S3_BUCKET=tf-codepipeline-source-timestamp-app
CLUSTER_NAME=tf-cluster-timestamp-app-0

mkdir -p tmp/

# Provision the cloud infrastructure
cd terraform

terraform init
AWS_DEFAULT_REGION=us-east-1 terraform apply --auto-approve

cd ..

# Push the Node.js code up to the specified S3 bucket

cd node-app
zip -r ../tmp/${SOURCE_ZIP_FILE} ./*
cd ..
aws s3 cp tmp/${SOURCE_ZIP_FILE} s3://${SOURCE_S3_BUCKET}/${SOURCE_ZIP_FILE}

# Deploy the K8S cluster
CURRENT_REGION=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]' | cat)
aws eks --region "${CURRENT_REGION}" update-kubeconfig --name "${CLUSTER_NAME}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml
kubectl apply -f deployments