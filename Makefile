current_dir = $(shell pwd)
TERRAFORM_CMD = cd terraform && terraform
TERRAFORM_VARS_FILE= $(current_dir)/terraform.auto.tfvars
SOURCE_ZIP_FILE = timestamp-app.zip
SOURCE_S3_BUCKET = tf-codepipeline-source-timestamp-app

CURRENT_REGION := $(shell aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]' | cat)
CLUSTER_NAME = tf-cluster-timestamp-app-0

default: provision

provision: tf-apply

deploy: cicd-zip-code cicd-upload-zip

clean: tf-destroy

tf-init:
	$(TERRAFORM_CMD) init

tf-plan:
	$(TERRAFORM_CMD) plan -var-file=$(TERRAFORM_VARS_FILE)

tf-apply:
	$(TERRAFORM_CMD) apply -var-file=$(TERRAFORM_VARS_FILE)

tf-destroy:
	$(TERRAFORM_CMD) destroy --auto-approve

cicd-zip-code:
	mkdir -p tmp/
	cd node-app && zip -r ../tmp/$(SOURCE_ZIP_FILE) *

cicd-upload-zip:
	aws s3 cp tmp/$(SOURCE_ZIP_FILE) s3://$(SOURCE_S3_BUCKET)/$(SOURCE_ZIP_FILE)

provision-cluster: kube-update-config
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml
	kubectl apply -f deployments

kube-update-config:
	aws eks --region $(CURRENT_REGION) update-kubeconfig --name $(CLUSTER_NAME)
