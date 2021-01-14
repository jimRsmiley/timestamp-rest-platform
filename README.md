# Timestamp REST App platform

## Setup

### Cloud infrastructure

The AWS infrastructure can be provisioned with the command:

`terraform plan && terraform apply`

## Deploy

Deploys of the service code are managed in AWS via the CodePipeline suite.

Builds are triggered by uploading the source code in a zipfile up to the S3 bucket polled by CodePipeline for changes.

## To-Dos

* Finish 
  * Run the Terraform code
  * Build the Node.js Docker image and push it
  * Deploy the image to the EKS cluster

## Directory Structure

### Kubernetes Deployments

Contained in the `./deployments` directory.

### Timestamp REST service

Contained in the `./node-app` directory.

### Terraform

The Terraform code is broken down into modules in the `./modules` directory.
