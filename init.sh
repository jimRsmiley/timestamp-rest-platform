#!/bin/bash

SOURCE_ZIP_FILE=timestamp-app.zip
SOURCE_S3_BUCKET=tf-codepipeline-source-timestamp-app

mkdir -p tmp/

# Provision the cloud infrastructure
cd terraform

terraform init
terraform apply --auto-approve

cd ..

# Push the Node.js code up to the specified S3 bucket

cd node-app
zip -r ../tmp/${SOURCE_ZIP_FILE} *
cd ..
aws s3 cp tmp/${SOURCE_ZIP_FILE} s3://${SOURCE_S3_BUCKET}/${SOURCE_ZIP_FILE}