# Build instructions for CI

## Tagged releases

In this example we will build the `rpi4` target

```bash
export TARGET=rpi4
export VERSION=$(cat $VERSION)
```

* Build the initramfs by reading the INITRAMFS_ARCH file in the target directory

```bash
export INITRAMFS_ARCH=$(cat targets/$TARGET)
./tools/scripts/create-build.sh initramfs/${INITRAMFS_ARCH}_defconfig o/initramfs-${INITRAMFS_ARCH}
cd o/initramfs-${INITRAMFS_ARCH}
make
```

Next build the target system

```bash
./tools/scripts/create-build.sh targets/$TARGET/defconfig o/$TARGET
cd o/$TARGET
make
```

Finally compress the `images` directory from the output to create the artifact

```bash
tar cJ -C o/$TARGET -f peridio-reference-platform-$TARGET-$VERSION.xz images --transform "s/images/peridio-reference-platform-$TARGET-$VERSION/"
```