#!/usr/bin/env bash

set -e

# Copy the fwup includes to the images dir
cp -rf $PERIDIO_DEFCONFIG_DIR/fwup_include $BINARIES_DIR

# Copy the uTee into place
cp -rf $BINARIES_DIR/uTee $BINARIES_DIR/uTee-6ullevk

mkimage -C none -A arm -T script -d $PERIDIO_DEFCONFIG_DIR/boot.scr $BINARIES_DIR/boot.scr
