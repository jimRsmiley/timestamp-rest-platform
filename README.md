# Timestamp REST App platform

## To-Dos

* Create a bootstrap process. (Makefile, ansible etc) to
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
