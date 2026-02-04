#!/usr/bin/env bash
set -e

cd rootfs
find . -print0 \
  | cpio --null -ov --format=newc \
  | gzip -9 > ../initramfs.cpio.gz
cd ..

KERNEL=linux-6.6.16/arch/x86/boot/bzImage
INITRD=initramfs.cpio.gz

qemu-system-x86_64 \
  -kernel "$KERNEL" \
  -initrd "$INITRD" \
  -nographic \
  -append "console=ttyS0 root=/dev/ram0"
