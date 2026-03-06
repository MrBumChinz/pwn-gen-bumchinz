#!/bin/bash -e

echo -e "\e[32m### Creating PwnaUI directories ###\e[0m"
install -v -d "${ROOTFS_DIR}/home/pi/pwnaui"
install -v -d "${ROOTFS_DIR}/home/pi/pwnaui/themes"
install -v -d "${ROOTFS_DIR}/usr/local/share/pwnaui"
install -v -d "${ROOTFS_DIR}/usr/local/share/pwnaui/webui"
install -v -d "${ROOTFS_DIR}/usr/local/share/pwnaui/themes"
install -v -d "${ROOTFS_DIR}/usr/local/share/pwnaui/assets"
install -v -d "${ROOTFS_DIR}/usr/local/share/pwnagotchi/custom-plugins"
install -v -d "${ROOTFS_DIR}/etc/pwnaui"
