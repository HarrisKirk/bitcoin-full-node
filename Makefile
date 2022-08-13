.PHONY: help build
.SILENT: 
DISC_CONTAINER_WORKDIR = /opt/devops-bci/bci-app
DOCKER_IMAGE_NAME = bci
DOCKER_IMAGE = $(DOCKER_IMAGE_NAME):latest
DOCKER_RUN_CMD = docker container run --dns=8.8.8.8 --rm --name=bci --workdir $(DISC_CONTAINER_WORKDIR) --user $(id -u):$(id -g)
DOCKER_ENV_STRING = -e LINODE_CLI_TOKEN -e LINODE_ROOT_PASSWORD 
DOCKER_VOLUME_MOUNTS = -v ~/.ssh:/root/.ssh 

help:
	@echo ""
	@echo "Makefile for bci - Bitcoin Cloud Infrastructure"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Basic build of bci image
	docker image build --tag $(DOCKER_IMAGE_NAME) . 1> /dev/null;\

bci: build ## Enter the command line environment to run bci (use #bci --help)  
	$(DOCKER_RUN_CMD) -it $(DOCKER_ENV_STRING) $(DOCKER_VOLUME_MOUNTS) $(DOCKER_IMAGE) /bin/bash -c "bci --install-completion 1> /dev/null; /bin/bash" ;\

clean: ## Remove all images and output folder
	docker system prune	--force >/dev/null ;\
	sudo rm -rf output

format: ## format the python code consistently
	$(DOCKER_RUN_CMD) -v $(PWD)/bci-app:$(DISC_CONTAINER_WORKDIR) $(DOCKER_IMAGE) black --verbose --line-length=120 --include bci $(DISC_CONTAINER_WORKDIR) ;\

test-int: build ## Integration test intended for CICD server
	$(DOCKER_RUN_CMD) -it $(DOCKER_ENV_STRING) $(DOCKER_VOLUME_MOUNTS) $(DOCKER_IMAGE) sh -c "chmod 775 ../run-test.sh; ../run-test.sh" ;\

test-docker: ## Verify docker is functioning properly to enable bci to run
	sudo chmod 666 /var/run/docker.sock ;\
	sudo usermod -aG docker $(USER) ;\
	docker run hello-world | egrep "(Hello|appears)"

	
