
DOCKER_CMD = podman
IMAGE_NAME = solr-crawler
IMAGE_VERSION = 1.1.2.solr
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
		--env MYC_SOLR_URL="http://10.1.1.1:8983/solr/testcore" \
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

.PHONY: run-solr
run-solr:
	$(DOCKER_CMD) run --rm -it -d -p 8983:8983 --name solr docker.io/library/solr:9

.PHONY: stop-solr
stop-solr:
	$(DOCKER_CMD) stop solr

.PHONY: solr-create-core
solr-create-core:
	$(DOCKER_CMD) exec -it solr bin/solr create_core -c testcore
