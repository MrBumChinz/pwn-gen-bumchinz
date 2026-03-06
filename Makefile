# pwn-gen-bumchinz Makefile
# Based on jayofelony/pwn-gen
#
# Prerequisites:
#   sudo apt-get install -y make git quilt qemu-user-static debootstrap zerofree \
#     libarchive-tools curl pigz arch-test qemu-utils qemu-system-arm qemu-user \
#     gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf coreutils parted zip \
#     dosfstools e2fsprogs libcap2-bin grep rsync xz-utils file bc gpg xxd \
#     bmap-tools kmod
#
# WORK_DIR can use up to 20GB of storage space
# refer to https://github.com/RPi-Distro/pi-gen/blob/master/README.md

BUILD_USER ?= $(shell whoami)
BUILD_HOME ?= $(shell eval echo ~$(BUILD_USER))
IMAGE_DIR ?= $(BUILD_HOME)/images

.PHONY: setup 32bit 64bit clean

setup:
	@if [ ! -d pi-gen-32bit ]; then \
		echo "Cloning pi-gen (32bit main branch)..."; \
		git clone --depth 1 https://github.com/RPI-Distro/pi-gen.git pi-gen-32bit; \
	fi
	@if [ ! -d pi-gen-64bit ]; then \
		echo "Cloning pi-gen (64bit arm64 branch)..."; \
		git clone --depth 1 -b arm64 https://github.com/RPI-Distro/pi-gen.git pi-gen-64bit; \
	fi

32bit: setup
	@mkdir -p "$(BUILD_HOME)/pwn-build/work-32bit" "$(IMAGE_DIR)"
	@sed -i 's|^WORK_DIR=.*|WORK_DIR="$(BUILD_HOME)/pwn-build/work-32bit"|' config-32bit
	@sed -i 's|^DEPLOY_DIR=.*|DEPLOY_DIR="$(IMAGE_DIR)"|' config-32bit
	sudo ./pi-gen-32bit/build.sh -c config-32bit
	@sudo chown -R $(BUILD_USER):$(BUILD_USER) "$(IMAGE_DIR)" 2>/dev/null || true

64bit: setup
	@mkdir -p "$(BUILD_HOME)/pwn-build/work-64bit" "$(IMAGE_DIR)"
	@sed -i 's|^WORK_DIR=.*|WORK_DIR="$(BUILD_HOME)/pwn-build/work-64bit"|' config-64bit
	@sed -i 's|^DEPLOY_DIR=.*|DEPLOY_DIR="$(IMAGE_DIR)"|' config-64bit
	sudo ./pi-gen-64bit/build.sh -c config-64bit
	@sudo chown -R $(BUILD_USER):$(BUILD_USER) "$(IMAGE_DIR)" 2>/dev/null || true

clean:
	@echo "Cleaning pi-gen working directories..."
	sudo rm -rf "$(BUILD_HOME)/pwn-build/work-32bit" 2>/dev/null || true
	sudo rm -rf "$(BUILD_HOME)/pwn-build/work-64bit" 2>/dev/null || true

distclean: clean
	@echo "Removing pi-gen directories..."
	rm -rf pi-gen-32bit pi-gen-64bit
