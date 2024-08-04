
DOCKER_CMD = podman
IMAGE_NAME = solr-crawler
IMAGE_VERSION = 2.0.1
REGISTRY_SERVER = inovtst9.u-aizu.ac.jp
REGISTRY_LIBRARY = library

.PHONY: clean
clean:
	mvn clean
	find . -name '*~' -exec rm {} \; -print

.PHONY: compile
compile: clean
	mvn compile

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
	$(DOCKER_CMD) run --rm -it \
		--env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		--env VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		$(IMAGE_NAME)

.PHONY: docker-build
docker-build: install
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME)

.PHONY: docker-build-prod
docker-build-prod: install
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME):$(IMAGE_VERSION) --no-cache

.PHONY: docker-tag
docker-tag:
	$(DOCKER_CMD) tag  $(IMAGE_NAME):$(IMAGE_VERSION) $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: docker-push
docker-push:
	$(DOCKER_CMD) push $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: native-image
native-image: install
	native-image -jar target/crawlerdemo-1.0-SNAPSHOT.jar

.PHONY: native-run
native-run:
	env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
		VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
