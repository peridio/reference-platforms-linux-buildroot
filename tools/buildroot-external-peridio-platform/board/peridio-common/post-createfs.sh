#!/usr/bin/env bash

set -e

#
# Post create filesystem hook
#
# Inputs:
#   $1  the images directory (where to put the .fw output)
#   $2  the path to fwup.conf
#   $2  the path to fwup-revert.conf
#   $BASE_DIR     the path to the buildroot output directory
#   $BINARIES_DIR the path to the images directory (normally $BASE_DIR/images)


if [ $# -lt 2 ]; then
    echo "Usage: $0 <BR images directory> <Path to fwup.conf> [Base firmware name]"
    exit 1
fi

FWUP_CONFIG=$2
FWUP_REVERT_CONFIG=$3

[ ! -f "$FWUP_CONFIG" ] && { echo "Error: $FWUP_CONFIG not found"; exit 1; }

# Copy the fwup config to the images directory so that
# it can be used to create images based on this one.
cp -f "$FWUP_CONFIG" "$BINARIES_DIR"
cp -f "$FWUP_REVERT_CONFIG" "$BINARIES_DIR"
cp -f "$BR2_EXTERNAL_PERIDIO_PLATFORM_PATH/board/peridio-common/platform-build.sh" "$BINARIES_DIR"

# CPIO /etc/fw_env.config for U-Boot env support in initramfs
$(cd $PERIDIO_DEFCONFIG_DIR/rootfs_overlay && find etc/fw_env.config -depth | cpio -o -H newC --owner=root:root --reproducible | cat > $BINARIES_DIR/fw_env.config.cpio)

