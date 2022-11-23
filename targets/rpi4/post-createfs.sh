#!/bin/sh

set -e

FWUP_CONFIG=$PERIDIO_DEFCONFIG_DIR/fwup.conf
$BR2_EXTERNAL_PERIDIO_PLATFORM_PATH/board/peridio-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG

