# Avocado

Avocado is a reference implementation of the Peridio Agent for embedded linux devices.

## Targets

* Raspberry Pi 4
* Seeed Studio reTerminal
* Generic x86_64
* QEmu (aarch64)
* iMX.6ULL EVK

## Building for a Target

In this example we will build the system for a Raspberry Pi 4 with the docker platform example

First lets build the initramfs

```bash
./tools/scripts/create-build.sh o/initramfs-aarch64 initramfs/aarch64_defconfig
cd o/initramfs-aarch64
make
```

Next build the target system

```bash
./tools/scripts/create-build.sh o/rpi4 targets/rpi4/defconfig tools/buildroot-external-peridio-avocado/configs/peridio_avocado_defconfig
cd o/rpi4
make

Finally, merge together the docker platform example and produce a fw file

```bash
cd
o/rpi4/images/platform-build.sh peridio-avocado-rpi4.fw platforms/docker
```

peridio-avocado-rpi4.xz

