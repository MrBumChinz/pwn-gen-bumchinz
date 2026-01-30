#!/bin/bash -e

cd /home/pi

echo -e "\e[32m### Installing PwnaUI from Mr Bumchinz Fork ###\e[0m"

# Clone the fork to get pwnaui
git clone https://github.com/MrBumChinz/Pwnagotchi-Fork---Mr-Bumchinz.git pwnaui-src

# Copy pwnaui components
if [ -d pwnaui-src/pwnaui ]; then
    cp -r pwnaui-src/pwnaui/* /home/pi/pwnaui/
fi

# Build pwnaui native renderer if Makefile exists
if [ -f /home/pi/pwnaui/Makefile ]; then
    echo -e "\e[32m### Building PwnaUI native renderer ###\e[0m"
    cd /home/pi/pwnaui
    make clean || true
    make
    make install || cp pwnaui /usr/local/bin/
fi

# Install Python components
if [ -d /home/pi/pwnaui/python ]; then
    echo -e "\e[32m### Installing PwnaUI Python modules ###\e[0m"
    cp -r /home/pi/pwnaui/python/* /home/pi/.pwn/lib/python3.*/site-packages/ 2>/dev/null || true
fi

# Install pwnaui service
if [ -f /home/pi/pwnaui/pwnaui.service ]; then
    cp /home/pi/pwnaui/pwnaui.service /etc/systemd/system/
    systemctl enable pwnaui.service
fi

# Cleanup
cd /home/pi
rm -rf pwnaui-src

echo -e "\e[32m### PwnaUI installation complete ###\e[0m"
