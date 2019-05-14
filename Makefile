DIR := $(realpath $(dir $(realpath $(MAKEFILE_LIST))))
IMAGES_DIR := $(DIR)/images
IMAGES_REGISTRY := docker.visual-craft.com
BUILD_IMAGE := $(DIR)/bin/build-image


.PHONY: php7.2-runtime
php7.2-runtime: | php7.2-7.3-build
	$(BUILD_IMAGE) \
		$(IMAGES_DIR)/runtime \
		$(IMAGES_DIR)/runtime/7.2/Dockerfile \
		$(IMAGES_REGISTRY)/$@

.PHONY: php7.3-runtime
php7.3-runtime: | php7.2-7.3-build
	$(BUILD_IMAGE) \
		$(IMAGES_DIR)/runtime \
		$(IMAGES_DIR)/runtime/7.3/Dockerfile \
		$(IMAGES_REGISTRY)/$@

.PHONY: php7.2-7.3-build
php7.2-7.3-build:
	$(BUILD_IMAGE) \
		$(IMAGES_DIR)/build \
		$(IMAGES_DIR)/build/7.2-7.3/Dockerfile \
		$(IMAGES_REGISTRY)/$@
