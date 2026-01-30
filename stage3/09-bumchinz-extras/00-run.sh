#!/bin/bash -e

echo -e "\e[32m### Installing Mr Bumchinz custom extras ###\e[0m"

# Install mode-toggle service
install -v -m 644 files/mode-toggle.service "${ROOTFS_DIR}/etc/systemd/system/mode-toggle.service"
install -v -m 755 files/mode_toggle.py "${ROOTFS_DIR}/usr/local/bin/mode_toggle.py"

# Install custom plugins
install -v -m 644 files/nexmon_stability.py "${ROOTFS_DIR}/usr/local/share/pwnagotchi/custom-plugins/nexmon_stability.py"
