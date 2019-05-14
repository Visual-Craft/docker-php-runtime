DIR := $(realpath $(dir $(realpath $(MAKEFILE_LIST))))
IMAGES_DIR := $(DIR)/images
IMAGES_REGISTRY := docker.visual-craft.com
BUILD_IMAGE := $(DIR)/bin/build-image


.PHONY: php7.2-runtime
php7.2-runtime: | php7.2-7.3-build
	$(BUILD_IMAGE) $(IMAGES_DIR)/7.2-runtime $(IMAGES_REGISTRY)/$@

.PHONY: php7.2-7.3-build
php7.2-7.3-build:
	$(BUILD_IMAGE) $(IMAGES_DIR)/7.2-7.3-build $(IMAGES_REGISTRY)/$@
