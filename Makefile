
DOCKER_CMD = podman
IMAGE_NAME = solr-crawler
IMAGE_VERSION = 1.1.1
REGISTRY_SERVER = inovtst9.u-aizu.ac.jp
REGISTRY_LIBRARY = library

.PHONY: clean
clean:
	find . -name '*~' -exec rm {} \; -print

.PHONY: run
run:
	env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		mvn exec:java

.PHONY: docker-build
docker-build:
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME)

.PHONY: docker-build-prod
docker-build-prod:
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME):$(IMAGE_VERSION) --no-cache

.PHONY: docker-tag
docker-tag:
	$(DOCKER_CMD) tag  $(IMAGE_NAME):$(IMAGE_VERSION) $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: docker-push
docker-push:
	$(DOCKER_CMD) push $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(IMAGE_VERSION)
