#!/bin/bash -e

# Install pre-built bettercap and pwngrid binaries into rootfs
# These are cross-compiled on the x86 host to avoid 12+ hour QEMU ARM builds.
# Falls back gracefully: if no pre-built binaries exist, the chroot scripts
# will compile from source (slow but works on native ARM).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "${SCRIPT_DIR}/files/bettercap" ]; then
    echo -e "\e[32m=== Installing pre-built bettercap ===\e[0m"
    install -v -m 755 "${SCRIPT_DIR}/files/bettercap" "${ROOTFS_DIR}/usr/local/bin/bettercap"
    file "${SCRIPT_DIR}/files/bettercap"
else
    echo -e "\e[33m=== No pre-built bettercap found, will compile in chroot ===\e[0m"
fi

if [ -f "${SCRIPT_DIR}/files/pwngrid" ]; then
    echo -e "\e[32m=== Installing pre-built pwngrid ===\e[0m"
    install -v -m 755 "${SCRIPT_DIR}/files/pwngrid" "${ROOTFS_DIR}/usr/local/bin/pwngrid"
    file "${SCRIPT_DIR}/files/pwngrid"
else
    echo -e "\e[33m=== No pre-built pwngrid found, will compile in chroot ===\e[0m"
fi
