# Timestamp REST App platform

## Prerequisites

* Terraform v0.14.2
* The `zip` command
* AWS CLI version 2

## Initialization

Run the shell script [./init.sh](./init.sh).

The script will:

1. Provision the AWS environment using Terraform

### Cloud infrastructure

The AWS infrastructure can be provisioned with the command:

`terraform plan && terraform apply`

## Deploy

Deploys of the service code are managed in AWS via the CodePipeline suite.

Builds are triggered by uploading the source code in a zipfile up to the S3 bucket polled by CodePipeline for changes.

## To-Dos

* the init.sh bootstrap script does the full run.

## Directory Structure

### Kubernetes Deployments

Contained in the `./deployments` directory.

### Timestamp REST service

Contained in the `./node-app` directory.

### Terraform

The Terraform code is broken down into modules in the `./modules` directory.
