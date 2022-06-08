#
# BLIN - Bitcoin on Linode
#
.PHONY: help build
.SILENT: pre-commit
DISC_CONTAINER_WORKDIR = /opt/devops-disc/disc-app
GIT_BRANCH = `git branch --all | grep "\*" | cut -d " " -f 2 | cut -c1-19`
DOCKER_IMAGE_NAME = blin
DOCKER_IMAGE = $(DOCKER_IMAGE_NAME):latest
DOCKER_RUN_CMD =  docker container run --dns=8.8.8.8 --rm --name=blin --workdir $(DISC_CONTAINER_WORKDIR) --user $(id -u):$(id -g)

help:
	@echo ""
	@echo "Makefile for BLIN"
	@echo "You are on git branch '$(GIT_BRANCH)'"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Basic build of image
	docker build --tag $(DOCKER_IMAGE_NAME) . ;\

run: build ## Run specific BLIN commands in the run.sh file 
	$(DOCKER_RUN_CMD) -e LINODE_CLI_TOKEN $(DOCKER_IMAGE)  sh -c "env" ;\

clean: ## Remove all images and output folder
	docker system prune	--force >/dev/null ;\
	sudo rm -rf output

