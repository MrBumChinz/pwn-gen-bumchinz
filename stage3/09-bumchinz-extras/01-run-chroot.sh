#!/bin/bash -e

echo -e "\e[32m### Enabling Mr Bumchinz services ###\e[0m"

# Enable mode-toggle service for PiSugar button support
systemctl enable mode-toggle.service

# Install smbus2 for PiSugar I2C communication
source /home/pi/.pwn/bin/activate
pip3 install smbus2
deactivate

echo -e "\e[32m### Mr Bumchinz extras installation complete ###\e[0m"
