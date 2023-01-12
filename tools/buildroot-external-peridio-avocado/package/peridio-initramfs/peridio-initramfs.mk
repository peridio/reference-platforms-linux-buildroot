#############################################################
#
# peridio_initramfs
#
#############################################################

PERIDIO_INITRAMFS_SITE = $(BR2_EXTERNAL_PERIDIO_AVOCADO_PATH)/package/peridio-initramfs
PERIDIO_INITRAMFS_SITE_METHOD = local
PERIDIO_INITRAMFS_LICENSE = Apache-2.0
PERIDIO_INITRAMFS_INSTALL_IMAGES = YES

define PERIDIO_INITRAMFS_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 644 $(@D)/peridio-initramfs-$(BR2_ARCH).xz $(BINARIES_DIR)
	$(INSTALL) -D -m 755 $(@D)/file-to-cpio.sh $(BINARIES_DIR)
endef

$(eval $(generic-package))
