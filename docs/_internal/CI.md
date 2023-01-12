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
./tools/scripts/create-build.sh o/initramfs-${INITRAMFS_ARCH} initramfs/${INITRAMFS_ARCH}_defconfig tools/buildroot-external-peridio-avocado/configs/peridio_initramfs_defconfig
cd o/initramfs-${INITRAMFS_ARCH}
make
```

Next build the target system

```bash
./tools/scripts/create-build.sh o/$TARGET targets/$TARGET/defconfig tools/buildroot-external-peridio-avocado/configs/peridio_avocado_defconfig
cd o/$TARGET
make
```

Finally compress the `images` directory from the output to create the artifact

```bash
tar cpJ -C o/$TARGET -f peridio-avocado-$TARGET-$VERSION.xz images --transform "s/^images/peridio-avocado-$TARGET-$VERSION/S"
```
