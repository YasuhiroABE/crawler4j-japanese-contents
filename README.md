# Sample Crawling Application for Japanese Contents

This is a sample application for crawling Japanese web content encoded in various character sets, such as EUC-JP, Shift-JIS, and ISO-2022JP, using org.mozilla.universalchardet.UniversalDetector and Crawler4j.

# References

* https://github.com/yasuhiroabe/crawler4j
* https://code.google.com/archive/p/juniversalchardet/

The original version of crawler4j was developed by Yasser Ganjisaffar, https://github.com/yasserg/crawler4j

# Prerequisites

* JRE (Java) 21+
* Maven (mvn)

# How to run

## Using config.properties

By default, this application uses the config.properties file.

```
# update TARGET_URL and VISIT_URL_PATTERN of config.properties
$ mvn compile
$ mvn install
$ mvn exec:java 
```

If you have GNU Make installed, you can run the same tasks as follows:

```
$ make compile
$ make install
$ make run
```

## Using environment variable

You can override values in config.properties using environment variables.

```
$ env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
    VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
    mvn exec:java
```

Alternatively, you can run the same task with GNU Make:

```
$ make run
```

Please refer to the run task in the Makefile for details.

# Configuration

The **config.properties** file defines the default settings for this application.

```
## crawl target URL
TARGET_URL=https://example.com/~user01/

## visit patterns escape rules:
VISIT_URL_PATTERN=^https?://example\\.com/(%7e|~)user1/.+

## crawler4j Storage Directory (You don't need to keep it on a persistent volume in k8s.)
CRAWLER4J_STORAGE_DIR=data/crawl/strage

## Pass-through rules for the shouldVisit method.
OK_FILTER=.*(\\.(text|txt|html|htm|yaml|yml|csv|json)|/)$
```

## TARGET_URL

The landing page URL where crawling starts.

## VISIT_URL_PATTERN

A Java regex used to identify which URLs should be followed for further crawling.

The crawler assesses URLs obtained from crawled pages, and if Matcher::find returns true, the URL is added to the crawling queue.

## CRAWLER4J_STORAGE_DIR

The directory used for the internal database to store temporary crawl states.

For typical use cases, the path doesn't need to be changed.

## OK_FILTER

This regex works alongside ``VISIT_URL_PATTERN`` to filter URLs.

Its purpose is to reduce unnecessary requests (e.g., skipping .css and .js files).

If you want to include PDF files, modify it like this:

```
OK_FILTER=.*(\\.(text|txt|html|htm|yaml|yml|csv|json|pdf)|/)$
```

# Containers

The default container engine used is `podman`.

If you prefer to use the ``docker`` command instead, you can modify the Makefile or set the DOCKER_CMD environment variable:

```
## To edit the Makefile
DOCKER_CMD ?= docker

## Otherwise, you can use the command parameter.
$ make DOCKER_CMD=docker docker-build
```

Several variables are defined in the Makefile, for example:

* DOCKER_OPT - Additional command line parameter, especially, if you use the SELinux on RHEL, please specify the `--security-opt label=disable` option to this variable.

Please adjust them as needed for your environment.

## Getting Started

To build and test your container image:

```
$ make docker-build
$ make docker-run
```

## Pushing Your Container Image to a Registry Server

To push your container image to a container registry, such as Docker Hub:

```
$ make docker-build-prod
$ make docker-tag
$ make docker-push
```

Before doing this, ensure the `REGISTRY_LIBRARY` varialbe in the  Makefile file is set to your username on hub.docker.com.

To change the target registry, edit the Makefile accordingly.

## Apple Silicon and other ARM Processors

For ARM based CPUs, update the DOCKER_PLATFORM variable:

```
DOCKER_PLATFORM ?= linux/arm64
```

Then, run the make command as usual.

Alternatively, you can specify it at runtime:

```
$ make DOCKER_PLATFORM=linux/arm64 docker-build
```

## Multiple Architecture Build

The multi-architecture build process depends on your container engine.

For `docker`, use the tasks of the `docker-buildx-` prefix.

```
$ make docker-buildx-init
$ make docker-buildx-setup
$ make docker-buildx-prod
```

For the default `podman` engine, use the following commands:

```
$ make podman-buildx-init
$ make podman-buildx-prod
$ make podman-buildx-push
```

# LICENSE

    Copyright 2025 Yasuhiro ABE <yasu@yasundial.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

