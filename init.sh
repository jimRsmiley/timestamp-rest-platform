#!/bin/bash

set -euxo pipefail

PROJECT_NAME=jsmiley-timestamp-app
SOURCE_ZIP_FILE=timestamp-app.zip
SOURCE_S3_BUCKET="tf-codepipeline-source-${PROJECT_NAME}"
CLUSTER_NAME=tf-cluster-${PROJECT_NAME}-0
CLUSTER_REGION=us-east-1

export AWS_DEFAULT_REGION=${CLUSTER_REGION}
mkdir -p tmp/

# Provision the cloud infrastructure
cd terraform

terraform init
terraform apply --auto-approve

cd ..

# Push the Node.js code up to the specified S3 bucket

cd node-app
zip -r ../tmp/${SOURCE_ZIP_FILE} ./*
cd ..
aws s3 cp tmp/${SOURCE_ZIP_FILE} s3://${SOURCE_S3_BUCKET}/${SOURCE_ZIP_FILE}

# Deploy the K8S cluster

# Add the kubeconfig locally
aws eks --region "${CLUSTER_REGION}" update-kubeconfig --name "${CLUSTER_NAME}"

# deploy the nginx controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml

# wait for the nginx controller 
kubectl wait --for=condition=ready --timeout=30s pods -l app.kubernetes.io/component=controller -n ingress-nginx

# now let's deploy our service
kubectl apply -f deployments