# Include Peridio reference platform specific packages
include $(sort $(wildcard $(BR2_EXTERNAL_PERIDIO_AVOCADO_PATH)/package/*/*.mk))

# PERIDIO_DEFCONFIG_DIR is used to reference files in configurations
# relative to wherever the _defconfig is stored.
PERIDIO_DEFCONFIG_DIR = $(dir $(call qstrip,$(BR2_DEFCONFIG)))
export PERIDIO_DEFCONFIG_DIR

PERIDIO_ARCH = $(call qstrip,$(BR2_ARCH))
export PERIDIO_ARCH

# It is common task to copy files to the images directory
# so that they can be included in a system image. Add this
# logic here so that a post-createfs script isn't required.
ifneq ($(call qstrip,$(BR2_PERIDIO_ADDITIONAL_IMAGE_FILES)),)
define PERIDIO_COPY_ADDITIONAL_IMAGE_FILES
	cp $(call qstrip,$(BR2_PERIDIO_ADDITIONAL_IMAGE_FILES)) $(BINARIES_DIR)
endef
TARGET_FINALIZE_HOOKS += PERIDIO_COPY_ADDITIONAL_IMAGE_FILES
endif
