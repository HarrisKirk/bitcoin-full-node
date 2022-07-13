#
# bci - Bitcoin Cloud Infrastructure
#
.PHONY: help build
.SILENT: 
DISC_CONTAINER_WORKDIR = /opt/devops-bci/bci-app
GIT_BRANCH = `git branch --all | grep "\*" | cut -d " " -f 2 | cut -c1-19`
DOCKER_IMAGE_NAME = bci
DOCKER_IMAGE = $(DOCKER_IMAGE_NAME):latest
DOCKER_RUN_CMD = docker container run --dns=8.8.8.8 --rm --name=bci --workdir $(DISC_CONTAINER_WORKDIR) --user $(id -u):$(id -g)
DOCKER_ENV_STRING = -e LINODE_CLI_TOKEN -e LINODE_ROOT_PASSWORD 
DOCKER_VOLUME_MOUNTS = -v ~/.ssh:/root/.ssh 
linode_tags = dev

help:
	@echo ""
	@echo "Makefile for bci"
	@echo "You are on git branch '$(GIT_BRANCH)'"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Basic build of bci image
	docker image build --quiet --tag $(DOCKER_IMAGE_NAME) . 1> /dev/null;\

cli: build ## Enter interactive shell to run linode-cli in the container.    
	$(DOCKER_RUN_CMD) -it $(DOCKER_ENV_STRING) $(DOCKER_VOLUME_MOUNTS) $(DOCKER_IMAGE) /bin/bash ;\

bci: build ## Run the bci app. Use linode_tags=<dev|test> (tag must be at least 3 chars)
	$(DOCKER_RUN_CMD) -it $(DOCKER_ENV_STRING) $(DOCKER_VOLUME_MOUNTS) $(DOCKER_IMAGE) /bin/bash -c "bci create $(linode_tags)";\

bci_debug: build ## ## Run the bci app. Use linode_tags=<dev|test> (tag must be at least 3 chars)
	$(DOCKER_RUN_CMD) -it $(DOCKER_ENV_STRING) $(DOCKER_VOLUME_MOUNTS) $(DOCKER_IMAGE) /bin/bash -c "bci create --log-level DEBUG $(linode_tags)";\

clean: ## Remove all images and output folder
	docker system prune	--force >/dev/null ;\
	sudo rm -rf output

format: ## format the python code consistently
	$(DOCKER_RUN_CMD) -v $(PWD)/bci-app:$(DISC_CONTAINER_WORKDIR) $(DOCKER_IMAGE) black --verbose --line-length=120 --include bci $(DISC_CONTAINER_WORKDIR) ;\
