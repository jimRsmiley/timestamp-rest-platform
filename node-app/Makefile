default: build run

build:
	docker build -t timestamp-app .

run: remove-container
	docker run -it -p 8080:3000 --name timestamp-app timestamp-app

remove-container:
	docker rm -f timestamp-app
