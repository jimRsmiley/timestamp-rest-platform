current_dir = $(shell pwd)
TERRAFORM_CMD = cd terraform && terraform
TERRAFORM_VARS_FILE= $(current_dir)/terraform.auto.tfvars
SOURCE_ZIP_FILE = timestamp-app.zip
SOURCE_S3_BUCKET = tf-codepipeline-source-timestamp-app

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

provision-cluster:
	aws eks --region us-east-1 update-kubeconfig --name tf-cluster-timestamp-app-0
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml

build:
	cd node-app && docker build -t timestamp-app . && \
		docker tag timestamp-app 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 888458450351.dkr.ecr.us-east-1.amazonaws.com
	cd node-app && docker push 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest
