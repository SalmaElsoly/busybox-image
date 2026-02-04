#!/usr/bin/env bash

set -e

KERNEL_VERSION=6.6.16

if [ ! -d linux-$KERNEL_VERSION ]; then
  wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$KERNEL_VERSION.tar.xz
  tar -xf linux-$KERNEL_VERSION.tar.xz
fi

cd linux-$KERNEL_VERSION

make defconfig
make -j$(nproc)