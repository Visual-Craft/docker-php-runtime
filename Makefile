DIR := $(realpath $(dir $(realpath $(MAKEFILE_LIST))))
BUILD_DIR := $(DIR)/.build

IMAGES_VERSION := 7.2-generic

BUILD_BASE_IMG_DIR := $(DIR)/build-base
BUILD_BASE_IMG_FILE := $(BUILD_BASE_IMG_DIR)/Dockerfile
BUILD_BASE_IMG_NAME := vc/php-build-base
BUILD_BASE_IMG_FULL_NAME := $(BUILD_BASE_IMG_NAME):$(IMAGES_VERSION)
BUILD_BASE_IMG_ID := $(shell echo $(BUILD_BASE_IMG_FULL_NAME) | sed -e 's/\//_/' -e 's/:/=/')
BUILD_BASE_IMG_META := $(BUILD_DIR)/$(BUILD_BASE_IMG_ID).meta

RUNTIME_BASE_IMG_DIR := $(DIR)/runtime-base
RUNTIME_BASE_IMG_FILE := $(RUNTIME_BASE_IMG_DIR)/Dockerfile
RUNTIME_BASE_IMG_NAME := vc/php-runtime-base
RUNTIME_BASE_IMG_FULL_NAME := $(RUNTIME_BASE_IMG_NAME):$(IMAGES_VERSION)
RUNTIME_BASE_IMG_ID := $(shell echo $(RUNTIME_BASE_IMG_FULL_NAME) | sed -e 's/\//_/' -e 's/:/=/')
RUNTIME_BASE_IMG_META := $(BUILD_DIR)/$(RUNTIME_BASE_IMG_ID).meta

RUNTIME_IMG_DIR := $(DIR)/runtime
RUNTIME_IMG_FILE := $(RUNTIME_IMG_DIR)/Dockerfile
RUNTIME_IMG_NAME := vc/php-runtime
RUNTIME_IMG_FULL_NAME := $(RUNTIME_IMG_NAME):$(IMAGES_VERSION)
RUNTIME_IMG_ID := $(shell echo $(RUNTIME_IMG_FULL_NAME) | sed -e 's/\//_/' -e 's/:/=/')
RUNTIME_IMG_META := $(BUILD_DIR)/$(RUNTIME_IMG_ID).meta



.PHONY: runtime
runtime: read-runtime-image-meta $(RUNTIME_IMG_META)

.PHONY: build-base
build-base: read-build-base-image-meta $(BUILD_BASE_IMG_META)

.PHONY: runtime-base
runtime-base: read-runtime-base-image-meta $(RUNTIME_BASE_IMG_META)

$(BUILD_BASE_IMG_META): $(BUILD_BASE_IMG_FILE) | $(BUILD_DIR)
	docker build \
		-f $(BUILD_BASE_IMG_FILE) \
		-t $(BUILD_BASE_IMG_FULL_NAME) \
		$(BUILD_BASE_IMG_DIR)
	$(DIR)/bin/generate-image-meta $(BUILD_BASE_IMG_FULL_NAME) $@

$(RUNTIME_BASE_IMG_META): $(RUNTIME_BASE_IMG_FILE) | $(BUILD_DIR)
	docker build \
		-f $(RUNTIME_BASE_IMG_FILE) \
		-t $(RUNTIME_BASE_IMG_FULL_NAME) \
		$(RUNTIME_BASE_IMG_DIR)
	$(DIR)/bin/generate-image-meta $(RUNTIME_BASE_IMG_FULL_NAME) $@

$(RUNTIME_IMG_META): $(RUNTIME_IMG_FILE) $(BUILD_BASE_IMG_META) $(RUNTIME_BASE_IMG_META) | $(BUILD_DIR)
	docker build \
		-f $(RUNTIME_IMG_FILE) \
		-t $(RUNTIME_IMG_FULL_NAME) \
		$(RUNTIME_IMG_DIR)
	$(DIR)/bin/generate-image-meta $(RUNTIME_IMG_FULL_NAME) $@

$(BUILD_DIR):
	mkdir -p $@

.PHONY: read-build-base-image-meta
read-build-base-image-meta:
	$(DIR)/bin/generate-image-meta $(BUILD_BASE_IMG_FULL_NAME) $(BUILD_BASE_IMG_META)

.PHONY: read-runtime-base-image-meta
read-runtime-base-image-meta:
	$(DIR)/bin/generate-image-meta $(RUNTIME_BASE_IMG_FULL_NAME) $(RUNTIME_BASE_IMG_META)

.PHONY: read-runtime-image-meta
read-runtime-image-meta:
	$(DIR)/bin/generate-image-meta $(RUNTIME_IMG_FULL_NAME) $(RUNTIME_IMG_META)
