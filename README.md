# Sample Crawling Application for Japanese Contents

This is a sample application to crawl Japanese contents encoded in various methods, such as EUC-JP, Shift-JIS, and ISO-2022JP, using the org.mozilla.universalchardet.UniversalDetector and Crawler4j.

# References

* https://github.com/yasuhiroabe/crawler4j
* https://code.google.com/archive/p/juniversalchardet/

The original version of crawler4j was developed by Yasser Ganjisaffar, https://github.com/yasserg/crawler4j

# Prerequisites

* JRE (Java) 21+

# How to run

## Using the config.properties

Basically, this application uses the config.properties by default.

```
# update TARGET_URL and VISIT_URL_PATTERN of config.properties
$ mvn compile
$ mvn install
$ mvn exec:java 
```

If you have a GNU make command, you

```
$ make compile
$ make install
$ make run
```

## Using the environment variable

you can use environment variables to overwrite the config.properties file.

```
$ env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
    VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
    mvn exec:java
```

Otherwise, you can simply execute the following command.

```
$ make run
```

Please see the run task of Makefile.

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

It is the landing page URL to start the crawling.

## VISIT_URL_PATTERN

It is the Java Regex text and uses for the detection of next crawling pages.

It will assess URLs obtained from web pages that have been crawled.

If the Matcher::find method returns true through the assessment process, then the URL is crawled as the next page.

## CRAWLER4J_STORAGE_DIR

This directory will be used for the internal database storage to store the temporary status.

For typical use cases, the path doesn't need to be changed.

## OK_FILTER

This parameter will be used as well as the VISIT_URL_PATTERN to assess each obtained URL.

The purpose of this parameter is to reduce the unnecessary access, such as .css and .js files.

If you would like to collect the PDF file, you can change this parameter as follows.

```
OK_FILTER=.*(\\.(text|txt|html|htm|yaml|yml|csv|json|pdf)|/)$
```

# Containers

The default container engine used is `podman`.

If you prefer to use the ``docker`` command, you can modify the Makefile or set the DOCKER_CMD environment variable:

```
## To edit the Makefile
DOCKER_CMD ?= docker

## Otherwise, you can use the command parameter.
$ make DOCKER_CMD=docker docker-build
```

There are some variables on the Makefile file, please overrite them for your environment.

* DOCKER_OPT - Additional command line parameter, especially, if you use the SELinux on RHEL, please specify the `--security-opt label=disable` option to this variable.

## Getting Started

To build and test your container image, execute the following commands:

```
$ make docker-build
$ make docker-run
```

## Pushing Your Container Image to a Registry Server

To push your container image to a registry server, such as hub.docker.com, run the commands as follows:

```
$ make docker-build-prod
$ make docker-tag
$ make docker-push
```

Before doing this, ensure the `REGISTRY_LIBRARY` varialbe in the  Makefile file is set to your username on hub.docker.com.

If you would like to change the registry server, you can edit the Makefile file.

## Apple Silicon and other ARM Processors

For ARM based CPUs, update the DOCKER_PLATFORM variable as shown below:

```
DOCKER_PLATFORM ?= linux/arm64
```

Then, run the make command as usual.

Otherwise, you can use the command line parameter as follows:

```
$ make DOCKER_PLATFORM=linux/arm64 docker-build
```

## Multiple Architecture Build

The multi-architecture build process depends on the container engine you are using.

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

