# Peridio Reference Platforms for Linux

Peridio reference platforms can be used to quickly and easily deploy custom application stacks to commonly supported Linux targets.

## Targets

* Raspberry Pi 4

## Building for a Target

In this example we will build the system for a Raspberry Pi 4 with the docker platform example

First lets build the initramfs

```bash
./tools/scripts/create-build.sh initramfs/aarch64_defconfig o/initramfs-aarch64
cd o/initramfs-aarch64
make
```

Next build the target system

```bash
./tools/scripts/create-build.sh targets/rpi4/defconfig o/rpi4
cd o/rpi4
make
```

Finally, merge together the docker platform example and produce a fw file

```bash
cd 
o/rpi4/images/platform-build.sh peridio-reference-platform-rpi4.fw platforms/docker
```

peridio-reference-platform-rpi4.xz

