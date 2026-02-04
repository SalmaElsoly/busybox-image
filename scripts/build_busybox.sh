#!/usr/bin/env bash

set -e

if [ ! -d busybox ]; then
  git clone https://github.com/mirror/busybox.git
fi

cd busybox
make defconfig

# enable static build
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/CONFIG_TC=y/# CONFIG_TC is not set/' .config
sed -i 's/CONFIG_FEATURE_TC=y/# CONFIG_FEATURE_TC is not set/' .config

# Ensure basic networking utilities are enabled
sed -i 's/# CONFIG_IFCONFIG is not set/CONFIG_IFCONFIG=y/' .config
sed -i 's/# CONFIG_ROUTE is not set/CONFIG_ROUTE=y/' .config
sed -i 's/# CONFIG_IP is not set/CONFIG_IP=y/' .config

make -j$(nproc)
