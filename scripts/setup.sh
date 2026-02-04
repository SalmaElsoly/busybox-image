#!/usr/bin/env bash

set -e

echo "Updating package lists..."
sudo apt update

echo "Installing core build tools..."
sudo apt install -y \
  build-essential \
  gcc \
  make \
  binutils \
  pkg-config

echo "Installing Linux kernel build dependencies..."
sudo apt install -y \
  bc \
  bison \
  flex \
  libssl-dev \
  libelf-dev \
  dwarves

echo "Installing BusyBox dependencies..."
sudo apt install -y \
  libncurses-dev

echo "Installing initramfs / rootfs tools..."
sudo apt install -y \
  cpio \
  gzip \
  xz-utils \
  coreutils

echo "Installing emulator..."
sudo apt install -y \
  qemu-system-x86

echo "Installing helpful utilities..."
sudo apt install -y \
  git \
  wget \
  curl

echo "All dependencies installed successfully"
