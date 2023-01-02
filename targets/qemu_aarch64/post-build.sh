#!/usr/bin/env bash

set -e

# Copy the fwup includes to the images dir
cp -rf $PERIDIO_DEFCONFIG_DIR/fwup_include $BINARIES_DIR
cp -rf $PERIDIO_DEFCONFIG_DIR/grub.cfg $BINARIES_DIR
