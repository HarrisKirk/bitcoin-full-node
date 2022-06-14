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
DOCKER_ENV_STRING = -e LINODE_CLI_TOKEN -e LINODE_ROOT_PASSWORD

help:
	@echo ""
	@echo "Makefile for BLIN"
	@echo "You are on git branch '$(GIT_BRANCH)'"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create: build ## Create a linode instance
	$(DOCKER_RUN_CMD) $(DOCKER_ENV_STRING) $(DOCKER_IMAGE)  sh -c "linode-cli linodes create --label hwk-A-newark --root_pass ${LINODE_ROOT_PASSWORD} --region us-east --image linode/ubuntu21.10 --type g6-standard-1 --authorized_keys 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC14pfsCoH0jGbcY5abffaQ7rmeZP0dClfzd/7u9LZir11x5njwo8mQW0LtUSPZOjwNunyOpQgI4P07RzdhldpjH5dEJ7SLgeoMBxUaHRuKQgm65PZd5k762eJj1H6CgibMPtZB3x1YN/z4nVSP9ae0lvu87uIHkOR6sWAlEwdO69Dan/VsJnfD+56kJfvumU3ueU1hXzlm4GK3oUF195UUBhdUF+ztv9PmVgCMzTjcIAde7QBQvmCWRT9hczrldbLPV3ZlEqM3wCR9YhXUMy8s/AUvNcPbFPLfKIGvo27KYQhD7y0ucXH5e+7K9nVK5riaSnILnzth8Ex5sH0yzkPklVKN0Dk1pfCRPXdl9Vfj6BN/ffh51mE4Kk64ppgYHa0a7VLuIn9YmGki/aDQE0Ah4+wHAtlVerfLtiKfXspkog4psiPxjrKi/i396DA4a6QJLkEZ/S9dGfUtzt3NHGlM9Or078T+paVlD6QtFkdRYnZ8WXTSS2HYshfMbtieIwU= hkirk@pop-os'" ;\

build: ## Basic build of image
	docker build --quiet --tag $(DOCKER_IMAGE_NAME) . ;\

cli: build ## Enter interactive shell to run linode-cli in the container.    
	$(DOCKER_RUN_CMD) -it $(DOCKER_ENV_STRING) $(DOCKER_IMAGE) /bin/bash ;\

list: build ## Run specific BLIN commands in the run.sh file 
	$(DOCKER_RUN_CMD) $(DOCKER_ENV_STRING) $(DOCKER_IMAGE)  sh -c "linode-cli linodes list" ;\

clean: ## Remove all images and output folder
	docker system prune	--force >/dev/null ;\
	sudo rm -rf output

