
DOCKER_CMD ?= podman
DOCKER_OPT ?=   ## --security-opt label=disable for podman on selinux
DOCKER_BUILDER ?= mabuilder
DOCKER_PLATFORM ?= linux/amd64
DOCKER_PLATFORMS ?= linux/amd64,linux/arm64

SHORT_NAME ?= solr-crawler
DOCKER_IMAGE_VERSION ?= latest
IMAGE_NAME := $(SHORT_NAME):$(DOCKER_IMAGE_VERSION)

REGISTRY_SERVER ?= docker.io
REGISTRY_LIBRARY ?= $(shell id -un)
PROD_IMAGE_NAME := $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME)

.PHONY: clean
clean:
	mvn clean
	find . -name '*~' -exec rm {} \; -print

.PHONY: compile
compile: clean
	mvn compile

.PHONY: package
package:
	mvn package

.PHONY: install
install:
	mvn install

.PHONY: run
run:
	env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		mvn exec:java

.PHONY: docker-run
docker-run:
	$(DOCKER_CMD) run --rm -it $(DOCKER_OPT) \
		--env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		--env VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		$(SHORT_NAME)

.PHONY: docker-build
docker-build: install
	$(DOCKER_CMD) build . --tag $(SHORT_NAME) --platform $(DOCKER_PLATFORM) $(DOCKER_OPT)

.PHONY: docker-build-prod
docker-build-prod: install
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME) --no-cache --platform $(DOCKER_PLATFORM) $(DOCKER_OPT)

.PHONY: docker-tag
docker-tag:
	$(DOCKER_CMD) tag  $(IMAGE_NAME) $(PROD_IMAGE_NAME)

.PHONY: docker-push
docker-push:
	$(DOCKER_CMD) push $(PROD_IMAGE_NAME)

##
## Multiple Architecture Build
##
## docker
.PHONY: docker-buildx-init
docker-buildx-init:
	$(DOCKER_CMD) buildx create --name $(DOCKER_BUILDER) --use $(DOCKER_OPT)

.PHONY: docker-buildx-setup
docker-buildx-setup:
	$(DOCKER_CMD) buildx use $(DOCKER_BUILDER) $(DOCKER_OPT)
	$(DOCKER_CMD) buildx inspect --bootstrap $(DOCKER_OPT)

.PHONY: docker-buildx-prod
docker-buildx-prod:
	$(DOCKER_CMD) buildx build --platform $(DOCKER_PLATFORMS) --tag $(PROD_IMAGE_NAME) --no-cache --push .

## podman
.PHONY: podman-buildx-init
podman-buildx-init:
	$(DOCKER_CMD) rmi $(IMAGE_NAME) || true
	$(DOCKER_CMD) manifest create $(IMAGE_NAME)

.PHONY: podman-buildx
podman-buildx:
	$(DOCKER_CMD) build . $(DOCKER_OPT) --tag $(IMAGE_NAME) --platform $(DOCKER_PLATFORMS)

.PHONY: podman-buildx-prod
podman-buildx-prod:
	$(DOCKER_CMD) $(DOCKER_OPT) rmi $(PROD_IMAGE_NAME) || true
	$(DOCKER_CMD) $(DOCKER_OPT) rmi $(IMAGE_NAME) || true
	$(DOCKER_CMD) build . $(DOCKER_OPT) --pull --no-cache --platform $(DOCKER_PLATFORMS) --manifest $(IMAGE_NAME)

.PHONY: podman-buildx-push
podman-buildx-push:
	$(DOCKER_CMD) manifest push $(IMAGE_NAME) $(PROD_IMAGE_NAME)
