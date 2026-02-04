#!/usr/bin/env bash

set -e
# install compiler
sudo apt-get update
sudo apt-get install -y build-essential 

# install busybox source code if not found
which busybox > /dev/null 2>&1
if [ $? -ne 0 ]; then
    git clone https://github.com/mirror/busybox.git
    cd busybox
    make defconfig
    make -j$(nproc)
    make install
fi

# install kernel
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.16.tar.xz
tar -xf linux-6.6.16.tar.xz



