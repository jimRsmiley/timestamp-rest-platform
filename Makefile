TERRAFORM_CMD = cd terraform && terraform

default: provision

provision: tf-apply

clean: tf-destroy

tf-plan:
	$(TERRAFORM_CMD) plan

tf-apply:
	$(TERRAFORM_CMD) apply --auto-approve

tf-destroy:
	$(TERRAFORM_CMD) destroy --auto-approve
	
provision-cluster:
	aws eks --region us-east-1 update-kubeconfig --name tf-cluster-timestamp-app-0
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml

build:
	cd node-app && docker build -t timestamp-app . && \
		docker tag timestamp-app 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 888458450351.dkr.ecr.us-east-1.amazonaws.com
	cd node-app && docker push 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest
