# Qemu aarch64

## Running Qemu

qemu-system-aarch64 \
      -M virt,secure=on \
      -bios images/flash.bin \
      -cpu cortex-a53 \
      -device virtio-blk-device,drive=hd0 \
      -device virtio-net-device,netdev=eth0 \
      -device virtio-rng-device,rng=rng0 \
      -drive file=peridio-avocado-qemu-aarch64.img,if=none,format=raw,id=hd0 \
      -m 1024 \
      -netdev user,id=eth0,hostfwd=tcp::10022-:22 \
      -no-acpi \
      -nographic \
      -object rng-random,filename=/dev/urandom,id=rng0 \
      -rtc base=utc,clock=host \
      -smp 2
