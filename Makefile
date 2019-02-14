DIR := $(realpath $(dir $(realpath $(MAKEFILE_LIST))))
VERSIONS_DIR := $(DIR)/versions
IMAGES_REGISTRY := docker.visual-craft.com
IMAGES_VERSION := $(shell git describe --tags 2>/dev/null | sed s/^v//)


.PHONY: build
build: php7.2-runtime

.PHONY: php7.2-runtime
php7.2-runtime: | php7.2-build
	sed -e 's#^\(FROM .*/php7.2-build\)$$#\1:$(IMAGES_VERSION)#' \
		$(VERSIONS_DIR)/7.2/runtime/Dockerfile \
		> $(VERSIONS_DIR)/7.2/runtime/Dockerfile-updated
	FORCE_REBUILD=y $(DIR)/bin/build-image \
		$(IMAGES_REGISTRY)/$@:$(IMAGES_VERSION) \
		$(VERSIONS_DIR)/7.2/runtime \
		$(VERSIONS_DIR)/7.2/runtime/Dockerfile-updated
	rm $(VERSIONS_DIR)/7.2/runtime/Dockerfile-updated

.PHONY: php7.2-build
php7.2-build:
	$(DIR)/bin/build-image \
		$(IMAGES_REGISTRY)/$@:$(IMAGES_VERSION) \
		$(VERSIONS_DIR)/7.2/build
