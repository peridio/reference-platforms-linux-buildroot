#!/usr/bin/env bash

set -e

#
# Peridio common post-build hook
#

PERIDIO_AVOCADO_VERSION=$(cat "$BR2_EXTERNAL_PERIDIO_AVOCADO_PATH/VERSION")

# Approximate an os-release
cat << EOF > "$TARGET_DIR/usr/lib/os-release"
NAME=Peridio Platform
ID=Peridio
PERIDIO_AVOCADO_VERSION=$PERIDIO_AVOCADO_VERSION
PERIDIO_BUILDROOT_VERSION=$BR2_VERSION
EOF
