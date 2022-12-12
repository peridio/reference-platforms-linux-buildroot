#!/bin/sh

set -e

# Copy the fwup includes to the images dir
cp -rf $PERIDIO_DEFCONFIG_DIR/fwup_include $BINARIES_DIR
cp -rf $PERIDIO_DEFCONFIG_DIR/grub.cfg $BINARIES_DIR

# Create the revert script for manually switching back to the previously
# active firmware.
#mkdir -p $TARGET_DIR/usr/share/fwup
#$HOST_DIR/usr/bin/fwup -c -f $PERIDIO_DEFCONFIG_DIR/fwup-revert.conf -o $TARGET_DIR/usr/share/fwup/revert.fw
