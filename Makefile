current_dir = $(shell pwd)
TERRAFORM_CMD = cd terraform && terraform
SOURCE_ZIP_FILE = timestamp-app.zip
SOURCE_S3_BUCKET = tf-codepipeline-source-timestamp-app
ARTIFACT_S3_BUCKET = tf-codepipeline-artifacts-timestamp-app

CURRENT_REGION := $(shell aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]' | cat)
CLUSTER_NAME = tf-cluster-jsmiley-timestamp-app-0

default: provision

provision: tf-apply

deploy: cicd-zip-code cicd-upload-zip

clean: s3-clean kube-delete tf-destroy

s3-clean:
	aws s3 rm s3://$(SOURCE_S3_BUCKET) --recursive
	aws s3 rm s3://$(ARTIFACT_S3_BUCKET) --recursive

tf-init:
	$(TERRAFORM_CMD) init

tf-plan:
	$(TERRAFORM_CMD) plan

tf-apply:
	$(TERRAFORM_CMD) apply

tf-output:
	$(TERRAFORM_CMD) output

tf-refresh:
	$(TERRAFORM_CMD) refresh

tf-destroy:
	$(TERRAFORM_CMD) destroy

cicd-zip-code:
	mkdir -p tmp/
	cd node-app && zip -r ../tmp/$(SOURCE_ZIP_FILE) *

cicd-upload-zip:
	aws s3 cp tmp/$(SOURCE_ZIP_FILE) s3://$(SOURCE_S3_BUCKET)/$(SOURCE_ZIP_FILE)

kube-provision-cluster: kube-update-config
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml
	kubectl apply -f deployments

kube-update-config:
	aws eks --region $(CURRENT_REGION) update-kubeconfig --name $(CLUSTER_NAME)

kube-delete:
	kubectl delete ns ingress-nginx

act:
	act \
		-P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 \
		--secret-file=./.secrets \
		-j terraform