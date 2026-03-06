#!/bin/bash -e

echo -e "\e[32m### Enabling Mr Bumchinz services ###\e[0m"

# Enable mode-toggle service for PiSugar button support
systemctl enable mode-toggle.service

# Install smbus2 for PiSugar I2C communication (system-wide, no venv)
pip3 install smbus2 --break-system-packages || pip3 install smbus2

echo -e "\e[32m### Mr Bumchinz extras installation complete ###\e[0m"
