DIR := $(realpath $(dir $(realpath $(MAKEFILE_LIST))))
IMAGES_DIR := $(DIR)/images
IMAGES_REGISTRY := docker.visual-craft.com
BUILD_IMAGE := $(DIR)/bin/build-image

DOCKERFILE_TPL := $(DIR)/images/runtime/templates/Dockerfile
DOCKERFILE_72 := $(DIR)/images/runtime/7.2/Dockerfile
DOCKERFILE_72_VARS := $(DIR)/images/runtime/7.2/variables.json
DOCKERFILE_73 := $(DIR)/images/runtime/7.3/Dockerfile
DOCKERFILE_73_VARS := $(DIR)/images/runtime/7.3/variables.json


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

.PHONY: dockerfiles
dockerfiles: $(DOCKERFILE_72) $(DOCKERFILE_73)

$(DOCKERFILE_72): $(DOCKERFILE_72_VARS) $(DOCKERFILE_TPL)
	$(DIR)/bin/render-template $(DOCKERFILE_TPL) $(DOCKERFILE_72_VARS) > $@

$(DOCKERFILE_73): $(DOCKERFILE_73_VARS) $(DOCKERFILE_TPL)
	$(DIR)/bin/render-template $(DOCKERFILE_TPL) $(DOCKERFILE_73_VARS) > $@
