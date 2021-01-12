build:
	cd node-app && docker build -t timestamp-app . && \
		docker tag timestamp-app 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 888458450351.dkr.ecr.us-east-1.amazonaws.com
	cd node-app && docker push 888458450351.dkr.ecr.us-east-1.amazonaws.com/timestamp-app:latest