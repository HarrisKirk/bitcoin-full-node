#
# BLIN - Bitcoin on Linode
#
.PHONY: help build
.SILENT: pre-commit
DISC_CONTAINER_WORKDIR = /opt/devops-blin
GIT_BRANCH = `git branch --all | grep "\*" | cut -d " " -f 2 | cut -c1-19`
DOCKER_IMAGE_NAME = blin
DOCKER_IMAGE = $(DOCKER_IMAGE_NAME):latest
DOCKER_RUN_CMD = docker container run --dns=8.8.8.8 --rm --name=blin --workdir $(DISC_CONTAINER_WORKDIR) --user $(id -u):$(id -g)
export BLIN_SSH_KEY=`cat ~/.ssh/id_rsa.pub`
DOCKER_ENV_STRING = -e LINODE_CLI_TOKEN -e LINODE_ROOT_PASSWORD -e BLIN_SSH_KEY

help:
	@echo ""
	@echo "Makefile for BLIN"
	@echo "You are on git branch '$(GIT_BRANCH)'"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create: build ## Create a linode instance
	$(DOCKER_RUN_CMD) $(DOCKER_ENV_STRING) $(DOCKER_IMAGE)  sh -c "linode-cli linodes create --authorized_keys '${BLIN_SSH_KEY}' --root_pass ${LINODE_ROOT_PASSWORD} --label hwk-newark --region us-east --image linode/ubuntu21.10 --type g6-standard-1 " ;\

build: ## Basic build of image
	docker build --quiet --tag $(DOCKER_IMAGE_NAME) . ;\

cli: build ## Enter interactive shell to run linode-cli in the container.    
	$(DOCKER_RUN_CMD) -it $(DOCKER_ENV_STRING) $(DOCKER_IMAGE) /bin/bash ;\

list: build ## Run specific BLIN commands in the run.sh file 
	$(DOCKER_RUN_CMD) $(DOCKER_ENV_STRING) $(DOCKER_IMAGE)  sh -c "linode-cli linodes list" ;\

clean: ## Remove all images and output folder
	docker system prune	--force >/dev/null ;\
	sudo rm -rf output

