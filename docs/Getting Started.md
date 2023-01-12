# Avocado

## Overview

Avocado is a reference implementation of the Peridio Agent for Linux capable microprocessor targets. The Avocado project consists of build scripts, command line tooling, and a runtime (AvocadOS) to help produce dynamic hardware platforms that are capable of deploying a variety of custom software with minimal dependency. AvocadOS imposes a variety of opinions to produce a scaleable, fault tolerant runtime with reproducible yet flexible application, system, and library management.

AvocadOS is a prebuilt target platform that is ready for you to integrate and deploy your application. AvocadOS is built upon the following principals and features:
systemd init
A/B filesystems for fault tolerant upgrades.

* 1 hardware partition called PlatformFS is reserved for user provided target configuration.
* A reserved block of dynamic storage space referred to as DynamicFS to be used for managing peridio installed application artifacts.
* AvocadOS InitramFS will merge the Avocado RootFS, the PlatformFS, and the DynamicFS partitions using an OverlayFS filesystem and switch root during boot.

These design decisions allow users to overlay their applications and libraries to the root filesystem by creating a filesystem structure and using mksquashfs to produce the PlatformFS. Therefore, any file in any relative path that is provided in that filesystem will appear as part of the root filesystem at runtime. Considering that systemd, the Linux kernel, and userspace applications operate mostly on well crafted files, AvocadOS is highly extensible with minimal dependency. Running your application is a matter of choosing an installation location and creating a systemd service file.

## Running you application on AvocadOS

Avocado requires minimal system dependencies to build functional firmware. You will need the following dependencies installed on your host system

```text
squashfs-tools
fwup
```

### Installation for MacOS

Install required tools using homebrew
```bash
brew install squashfs fwup
```

### Installation for Linux
Install the latest release of fwup from the releases page at https://github.com/fwup-home/fwup

```bash
sudo apt install squashfs-tools
```



## Enabling SSH Access
Create a file in your PlatformFS source directory at /etc/ssh/authorized_keys. Add as many ssh keys to this list as you would like to allow access to the system. Be sure to set the file / directory permissions of the ssh and authorized_keys files

```bash
chmod 755 ssh
chmod 640 ssh
```
