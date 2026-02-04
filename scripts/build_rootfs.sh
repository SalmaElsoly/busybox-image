#!/usr/bin/env bash

set -e
ROOTFS_DIR=rootfs
#create rootfs dir
mkdir -p $ROOTFS_DIR

#copy busybox to rootfs
install -Dm755 busybox/busybox $ROOTFS_DIR/bin/busybox

#make rootfs/bin/busybox executable
chmod +x $ROOTFS_DIR/bin/busybox

#populate rootfs with busybox symlinks
mkdir -p "$ROOTFS_DIR"/{bin,sbin,usr/bin,usr/sbin}
for prog in $($ROOTFS_DIR/bin/busybox --list); do
  ln -sf /bin/busybox "$ROOTFS_DIR/bin/$prog" 2>/dev/null || true
done

mkdir -p \
  "$ROOTFS_DIR"/{dev,proc,sys,tmp,etc}

cat > "$ROOTFS_DIR/init" << 'EOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev
exec /bin/sh
EOF

chmod +x "$ROOTFS_DIR/init"

install -Dm644 /etc/resolv.conf $ROOTFS_DIR/etc/resolv.conf

