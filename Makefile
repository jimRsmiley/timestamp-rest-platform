default: provision

provision: tf-apply

tf-plan:
	terraform plan

tf-apply:
	terraform apply --auto-approve

tf-destroy:
	terraform destroy --auto-approve

clean: tf-destroy

provision-cluster:
	aws eks --region us-east-1 update-kubeconfig --name tf-cluster-timestamp-app-0
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml

build:
	cd node-app && docker build -t timestamp-app . && \
		docker tag timestamp-app 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 888458450351.dkr.ecr.us-east-1.amazonaws.com
	cd node-app && docker push 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest
