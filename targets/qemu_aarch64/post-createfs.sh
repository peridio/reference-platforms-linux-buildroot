#!/bin/sh

set -e

# Create flash.bin TF-A FIP image from bl1.bin and fip.bin
dd if="${BINARIES_DIR}/bl1.bin" of="${BINARIES_DIR}/flash.bin" bs=1M
dd if="${BINARIES_DIR}/fip.bin" of="${BINARIES_DIR}/flash.bin" seek=64 bs=4096 conv=notrunc

# Override the default GRUB configuration file with our own.
cp -f "${PERIDIO_DEFCONFIG_DIR}/grub.cfg" "${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg"

FWUP_CONFIG=$PERIDIO_DEFCONFIG_DIR/fwup.conf
FWUP_REVERT_CONFIG=$PERIDIO_DEFCONFIG_DIR/fwup-revert.conf
$BR2_EXTERNAL_PERIDIO_PLATFORM_PATH/board/peridio-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG $FWUP_REVERT_CONFIG
