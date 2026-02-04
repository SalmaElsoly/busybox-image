.PHONY: all setup busybox kernel rootfs run run-cloud clean help

KERNEL_VERSION := 6.6.16
KERNEL_DIR := linux-$(KERNEL_VERSION)
KERNEL_IMAGE := $(KERNEL_DIR)/arch/x86/boot/bzImage
BUSYBOX_DIR := busybox
ROOTFS_DIR := rootfs
INITRAMFS := initramfs.cpio.gz

all: rootfs kernel
	@echo "Build complete! Run 'make run' to test the system"

help:
	@echo "BusyBox Linux Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make setup      - Install system dependencies"
	@echo "  make busybox    - Build BusyBox"
	@echo "  make kernel     - Build Linux kernel"
	@echo "  make rootfs     - Create root filesystem"
	@echo "  make run        - Run system in QEMU"
	@echo "  make all        - Build everything (default)"
	@echo "  make clean      - Remove build artifacts"
	@echo "  make distclean  - Remove everything including downloads"
	@echo ""

setup:
	@echo "Installing dependencies..."
	@bash scripts/setup.sh

busybox: 
	@echo "Building BusyBox..."
	@bash scripts/build_busybox.sh

kernel: 
	@echo "Building kernel..."
	@bash scripts/build_kernel.sh

rootfs: busybox
	@echo "Building rootfs..."
	@bash scripts/build_rootfs.sh

run: rootfs kernel
	@bash scripts/run.sh

run-cloud: rootfs kernel
	@bash scripts/run_cloud.sh

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(ROOTFS_DIR)
	rm -f $(INITRAMFS)
	@echo "Clean complete"

distclean: clean
	@echo "Removing all build files and downloads..."
	rm -rf $(BUSYBOX_DIR)
	rm -rf $(KERNEL_DIR)
	rm -f linux-*.tar.xz
	@echo "Distclean complete"
