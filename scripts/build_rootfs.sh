#!/usr/bin/env bash

set -e

#create rootfs dir
mkdir -p rootfs

#copy busybox to rootfs
install -Dm755 busybox/busybox rootfs/bin/busybox

#make rootfs/bin/busybox executable
chmod +x rootfs/bin/busybox

#populate rootfs
rootfs/bin/busybox --install -s -m rootfs
install -Dm644 /etc/resolv.conf rootfs/etc/resolv.conf

