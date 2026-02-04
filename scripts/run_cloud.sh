#!/usr/bin/env bash
set -e

# Build initramfs if it doesn't exist or is outdated
if [ ! -f "../initramfs.cpio.gz" ] || [ "../initramfs.cpio.gz" -ot "rootfs" ]; then
  echo "Building initramfs..."
  cd rootfs
  find . -print0 \
    | cpio --null -ov --format=newc \
    | gzip -9 > ../initramfs.cpio.gz
  cd ..
fi

KERNEL=linux-6.6.16/arch/x86/boot/bzImage
INITRD=initramfs.cpio.gz

# check if cloud-hypervisor is installed
if ! command -v cloud-hypervisor &> /dev/null; then
  echo "Error: cloud-hypervisor not found!"
  echo "will install Cloud Hypervisor:"
  wget wget https://github.com/cloud-hypervisor/cloud-hypervisor/releases/latest/download/cloud-hypervisor-static
  sudo mv cloud-hypervisor-static /usr/local/bin/cloud-hypervisor
  sudo chmod +x /usr/local/bin/cloud-hypervisor
fi

echo "Starting Cloud Hypervisor..."
cloud-hypervisor \
  --kernel "$KERNEL" \
  --initramfs "$INITRD" \
  --console serial \
  --serial tty \
  --cpus 2 \
  --memory 512 \
  --kernel-args "console=ttyS0 root=/dev/ram0"
