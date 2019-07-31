.DEFAULT_GOAL := help

# Settable variables ----------------------------------------------------------
# Set output prefix (local directory if not specified)
prefix ?= $(shell pwd)
# Set image for Docker
imgrepo ?= nocquidant/huslibu
# Set target tag for Docker image
imgtag ?= latest
# Set Docker username for pushing image to registry
DOCKER_USER ?= unknown
# Set Docker password for pushing image to registry
DOCKER_PASS ?= unknown
# Git commit hash
gitcommit := $(shell git rev-parse --short HEAD)
gituntrackedchanges := $(shell git status --porcelain --untracked-files=no)
ifneq ($(gituntrackedchanges),)
	gitcommit := $(gitcommit)-dirty
endif

# Util stuff ------------------------------------------------------------------
print-%: ; @echo $*=$($*)

# -----------------------------------------------------------------------------  
.PHONY: docker-check-env
docker-check-env: Dockerfile ; @which docker > /dev/null

.PHONY: docker-login
docker-login: docker-check-env
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}

.PHONY: image
image: docker-check-env ## Builds Docker image
	docker build -f Dockerfile -t $(imgrepo):git-$(gitcommit) .

.PHONY: tag-image
tag-image: docker-check-env ## Tags image with target tag $(imgtag) which should be the build #id
	docker tag $(imgrepo):git-$(gitcommit) $(imgrepo):$(imgtag)

.PHONY: push-image
push-image: ## Pushes image to Docker Hub
	docker push $(imgrepo)

# -----------------------------------------------------------------------------
help: ## Displays this help 
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)