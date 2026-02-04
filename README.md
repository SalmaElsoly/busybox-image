# BusyBox Image

A complete build system for creating a minimal Linux distribution using BusyBox and a custom Linux kernel. This project builds a static BusyBox binary, compiles the Linux kernel, creates a root filesystem, and packages it all into an initramfs that can be booted with QEMU or Cloud Hypervisor.

## Features

- **Static BusyBox Build**: Builds BusyBox with all common utilities statically linked
- **Custom Linux Kernel**: Compiles Linux kernel 6.6.16 with minimal configuration
- **Root Filesystem**: Creates a minimal root filesystem with BusyBox as init
- **Initramfs**: Packages the rootfs into a compressed CPIO archive
- **QEMU Support**: Run the complete system in QEMU
- **Cloud Hypervisor Support**: Alternative hypervisor support

## Prerequisites

- Linux host system
- QEMU (for `make run`)
- Cloud Hypervisor (optional, for `make run-cloud`)
- Build dependencies (automatically installed by `make setup`)

## Quick Start

```bash
# Clone and build everything
git clone <repository-url>
cd busybox-image
make setup    # Install dependencies (requires sudo)
make all      # Build everything

# Run in QEMU
make run

# Or run in Cloud Hypervisor
make run-cloud
```

## Build Targets

### `make setup`

Installs all required system dependencies:

- Build tools (gcc, make, etc.)
- QEMU
- Required libraries (ncurses-devel, etc.)

### `make busybox`

- Downloads BusyBox source
- Configures with default settings
- Builds with static linking
- Installs to `busybox/` directory

### `make kernel`

- Downloads Linux kernel 6.6.16
- Applies minimal configuration
- Builds the kernel
- Produces `linux-6.6.16/arch/x86/boot/bzImage`

### `make rootfs`

- Creates root filesystem directory structure
- Installs BusyBox and creates symlinks for all applets
- Creates `/init` script that mounts proc, sys, dev and starts shell
- Copies `/etc/resolv.conf` for network access

### `make run`

- Builds initramfs from rootfs
- Launches QEMU with kernel and initramfs
- Uses serial console (ttyS0) for output

### `make run-cloud`

- Builds initramfs from rootfs
- Launches Cloud Hypervisor with kernel and initramfs
- Uses serial console for output
- Requires Cloud Hypervisor to be installed

### `make all`

Builds everything: `rootfs` and `kernel` (busybox is built as dependency)

## Project Structure

```
busybox-image/
├── Makefile                 # Main build system
├── README.md               # This file
├── scripts/                # Build scripts
│   ├── setup.sh           # Dependency installation
│   ├── build_busybox.sh   # BusyBox build process
│   ├── build_kernel.sh    # Kernel build process
│   ├── build_rootfs.sh    # Root filesystem creation
│   └── run.sh             # QEMU launcher
├── busybox/               # BusyBox source and build
├── linux-6.6.16/         # Linux kernel source
├── rootfs/               # Generated root filesystem
└── initramfs.cpio.gz     # Generated initramfs
```

## Configuration

### BusyBox Configuration

The BusyBox configuration is in `scripts/build_busybox.sh`. Key settings:

- Static linking (`CONFIG_STATIC=y`)
- All applets enabled
- No installation to system directories

### Kernel Configuration

The kernel uses `defconfig` with minimal modifications in `scripts/build_kernel.sh`:

- Initramfs support
- Basic drivers for QEMU
- Serial console support

### Root Filesystem

The rootfs is created by `scripts/build_rootfs.sh`:

- `/init` - Main init script
- `/bin/busybox` - BusyBox binary
- `/bin/*` - Symlinks to BusyBox applets
- `/dev`, `/proc`, `/sys`, `/tmp` - Standard mount points

## Usage Examples

### Building Individual Components

```bash
# Build just BusyBox
make busybox

# Build just the kernel
make kernel

# Create just the rootfs
make rootfs
```

### Cleaning

```bash
# Remove build artifacts
make clean

# Remove everything including downloads
make distclean
```

## Customization

### Adding Files to Rootfs

Modify `scripts/build_rootfs.sh` to add additional files:

```bash
# Add custom configuration
cp myconfig "$ROOTFS_DIR/etc/"

# Add additional binaries
cp mybinary "$ROOTFS_DIR/bin/"
```

### Modifying Init Script

The init script is at the end of `scripts/build_rootfs.sh`. Customize it to:

- Start specific services
- Mount additional filesystems
- Run initialization scripts

### Changing Kernel Configuration

Edit `scripts/build_kernel.sh` to use a custom config:

```bash
# Use custom config
cp myconfig linux-6.6.16/.config
make -C linux-6.6.16 olddefconfig
```

## Resources

- [BusyBox Documentation](https://busybox.net/FAQ.html)
- [Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/)
- [QEMU Documentation](https://www.qemu.org/docs/master/)
- [Cloud Hypervisor Documentation](https://cloud-hypervisor.org/)
