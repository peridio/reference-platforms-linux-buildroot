#!/bin/sh

#
# Build the Peridio Platform with your code
#
# Inputs:
#   $1 = The output filename
#   $2..n = Paths to overlays

set -e

readlink_f () {
    cd "$(dirname "$1")" > /dev/null
    filename="$(basename "$1")"
    if [[ -h "$filename" ]]; then
        readlink_f "$(readlink "$filename")"
    else
        echo "$(pwd -P)/$filename"
    fi
}

# Determine the BINARIES_DIR source directory
BINARIES_DIR=$(dirname $(readlink_f "${BASH_SOURCE[0]}"))
if [[ ! -e $BINARIES_DIR ]]; then
    echo "ERROR: Can't determine script directory!"
    exit 1
fi

FWUP=$(command -v fwup || echo "/usr/bin/fwup")
if [[ ! -e "$FWUP" ]]; then
    echo "platform-build: ERROR: Please install fwup first"
    exit 1
fi

MKSQUASHFS=$(command -v mksquashfs || echo "/usr/bin/mksquashfs")
if [[ ! -e "$MKSQUASHFS" ]]; then
    echo "platform-build: ERROR: Please install mksquashfs first"
    exit 1
fi

OUTPUT=$1
PLATFORMFS_DIR=$2
FWUP_CONFIG="$BINARIES_DIR/fwup.conf"
FWUP_REVERT_CONFIG="$BINARIES_DIR/fwup-revert.conf"

PERIDIO_PLATFORM_META_PRODUCT=${PERIDIO_PLATFORM_META_PRODUCT:-peridio-platform}
PERIDIO_PLATFORM_META_VERSION=${PERIDIO_PLATFORM_META_VERSION:-0.1.0}
PERIDIO_PLATFORM_META_DESCRIPTION=${PERIDIO_PLATFORM_META_DESCRIPTION:-peridio-reference-platform}
PERIDIO_PLATFORM_META_AUTHOR=${PERIDIO_PLATFORM_META_AUTHOR:-peridio}

PERIDIO_PLATFORM_DISK_UUID=${PERIDIO_PLATFORM_DISK_UUID:-$(uuidgen)}
PERIDIO_PLATFORM_BOOT_PART_UUID=${PERIDIO_PLATFORM_BOOT_PART_UUID:-$(uuidgen)}
PERIDIO_PLATFORM_ROOTFS_PART_UUID=${PERIDIO_PLATFORM_ROOTFS_PART_UUID:-$(uuidgen)}
PERIDIO_PLATFORM_PLATFORMFS_PART_UUID=${PERIDIO_PLATFORM_PLATFORMFS_PART_UUID:-$(uuidgen)}
PERIDIO_PLATFORM_DATA_PART_UUID=${PERIDIO_PLATFORM_DATA_PART_UUID:-$(uuidgen)}
echo "Peridio Reference Platform Builder"
echo ""
echo "Metadata" 
echo "  product:     $PERIDIO_PLATFORM_META_PRODUCT"
echo "  version:     $PERIDIO_PLATFORM_META_VERSION"
echo "  description: $PERIDIO_PLATFORM_META_DESCRIPTION" 
echo "  author:      $PERIDIO_PLATFORM_META_AUTHOR"
echo ""
echo "Disk UUIDs"
echo "  disk:        $PERIDIO_PLATFORM_DISK_UUID"
echo "  boot:        $PERIDIO_PLATFORM_BOOT_PART_UUID"
echo "  rootfs:      $PERIDIO_PLATFORM_ROOTFS_PART_UUID"
echo "  platform:    $PERIDIO_PLATFORM_PLATFORMFS_PART_UUID" 
echo "  data:        $PERIDIO_PLATFORM_DATA_PART_UUID"
echo ""
echo "Creating revert script"
mkdir -p "$PLATFORMFS_DIR/usr/share/peridio"
BINARIES_DIR=$BINARIES_DIR \
PERIDIO_PLATFORM_META_PRODUCT=$PERIDIO_PLATFORM_META_PRODUCT \
PERIDIO_PLATFORM_META_VERSION=$PERIDIO_PLATFORM_META_VERSION \
PERIDIO_PLATFORM_META_DESCRIPTION=$PERIDIO_PLATFORM_META_DESCRIPTION \
PERIDIO_PLATFORM_META_AUTHOR=$PERIDIO_PLATFORM_META_AUTHOR \
PERIDIO_PLATFORM_DISK_UUID=$PERIDIO_PLATFORM_DISK_UUID \
PERIDIO_PLATFORM_BOOT_PART_UUID=$PERIDIO_PLATFORM_BOOT_PART_UUID \
PERIDIO_PLATFORM_ROOTFS_PART_UUID=$PERIDIO_PLATFORM_ROOTFS_PART_UUID \
PERIDIO_PLATFORM_PLATFORMFS_PART_UUID=$PERIDIO_PLATFORM_PLATFORMFS_PART_UUID \
PERIDIO_PLATFORM_DATA_PART_UUID=$PERIDIO_PLATFORM_DATA_PART_UUID \
$FWUP -c -f "$FWUP_REVERT_CONFIG" -o "$PLATFORMFS_DIR/usr/share/peridio/revert.fw"
echo ""
echo "Writing files to platformfs"
$MKSQUASHFS "$PLATFORMFS_DIR" "$BINARIES_DIR/platformfs.squashfs" -noappend -no-recovery -no-progress -all-root -quiet -info -progress

echo ""
echo "Finished creating PlatformFS"
echo ""

echo "Creating Peridio artifact"

BINARIES_DIR=$BINARIES_DIR \
PERIDIO_PLATFORM_META_PRODUCT=$PERIDIO_PLATFORM_META_PRODUCT \
PERIDIO_PLATFORM_META_VERSION=$PERIDIO_PLATFORM_META_VERSION \
PERIDIO_PLATFORM_META_DESCRIPTION=$PERIDIO_PLATFORM_META_DESCRIPTION \
PERIDIO_PLATFORM_META_AUTHOR=$PERIDIO_PLATFORM_META_AUTHOR \
PERIDIO_PLATFORM_DISK_UUID=$PERIDIO_PLATFORM_DISK_UUID \
PERIDIO_PLATFORM_BOOT_PART_UUID=$PERIDIO_PLATFORM_BOOT_PART_UUID \
PERIDIO_PLATFORM_ROOTFS_PART_UUID=$PERIDIO_PLATFORM_ROOTFS_PART_UUID \
PERIDIO_PLATFORM_PLATFORMFS_PART_UUID=$PERIDIO_PLATFORM_PLATFORMFS_PART_UUID \
PERIDIO_PLATFORM_DATA_PART_UUID=$PERIDIO_PLATFORM_DATA_PART_UUID \
$FWUP -c -f "$FWUP_CONFIG" -o "$OUTPUT" 

echo ""
echo "Done!"
echo ""
echo "Run the following to burn to SD card:"
echo "  fwup $OUTPUT"
