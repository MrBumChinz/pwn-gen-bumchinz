#!/bin/bash -e

cd /home/pi

echo -e "\e[32m### Installing PwnaUI from Mr Bumchinz Fork ###\e[0m"

# Clone the fork to get pwnaui + system components
git clone --depth 1 https://github.com/MrBumChinz/Pwnagotchi-Fork---Mr-Bumchinz.git pwnaui-src

# ---- Build PwnaUI native renderer ----
if [ -d pwnaui-src/pwnaui ] && [ -f pwnaui-src/pwnaui/Makefile ]; then
    echo -e "\e[32m### Building PwnaUI native C renderer ###\e[0m"
    cd /home/pi/pwnaui-src/pwnaui
    make clean 2>/dev/null || true
    make
    install -m 755 bin/pwnaui /usr/local/bin/pwnaui
    echo -e "\e[32m### PwnaUI binary installed ###\e[0m"
else
    echo -e "\e[31m### WARNING: pwnaui source not found, skipping build ###\e[0m"
fi

cd /home/pi

# ---- Install WebUI ----
if [ -d pwnaui-src/pwnaui/webui ]; then
    echo -e "\e[32m### Installing PwnaUI WebUI ###\e[0m"
    cp -r pwnaui-src/pwnaui/webui/* /usr/local/share/pwnaui/webui/
fi

# ---- Install Themes ----
if [ -d pwnaui-src/pwnaui/themes ]; then
    echo -e "\e[32m### Installing PwnaUI themes ###\e[0m"
    cp -r pwnaui-src/pwnaui/themes/* /usr/local/share/pwnaui/themes/
fi

# ---- Install Assets (icons, fonts) ----
if [ -d pwnaui-src/pwnaui/assets ]; then
    echo -e "\e[32m### Installing PwnaUI assets ###\e[0m"
    cp -r pwnaui-src/pwnaui/assets/* /usr/local/share/pwnaui/assets/
fi

# ---- Install hostname sync script ----
if [ -f pwnaui-src/pwnaui/scripts/pwnaui-hostname-sync ]; then
    echo -e "\e[32m### Installing hostname sync script ###\e[0m"
    install -m 755 pwnaui-src/pwnaui/scripts/pwnaui-hostname-sync /usr/local/bin/pwnaui-hostname-sync
fi

# ---- Install WiFi recovery script ----
if [ -f pwnaui-src/pwnaui/scripts/pwnaui_wifi_recovery.sh ]; then
    echo -e "\e[32m### Installing WiFi recovery script ###\e[0m"
    install -m 755 pwnaui-src/pwnaui/scripts/pwnaui_wifi_recovery.sh /usr/local/bin/pwnaui_wifi_recovery
fi

# ---- Build and install Bluetooth GPS receiver ----
if [ -f pwnaui-src/system/bt_gps_receiver.c ]; then
    echo -e "\e[32m### Building Bluetooth GPS receiver ###\e[0m"
    cd /home/pi
    gcc -O2 -Wall -o bt_gps_receiver pwnaui-src/system/bt_gps_receiver.c -lbluetooth -lpthread
    install -m 755 bt_gps_receiver /usr/local/bin/bt_gps_receiver
    rm -f bt_gps_receiver
fi

cd /home/pi

# ---- Install systemd services ----
echo -e "\e[32m### Installing PwnaUI systemd services ###\e[0m"

# PwnaUI main service
if [ -f pwnaui-src/pwnaui/pwnaui.service ]; then
    cp pwnaui-src/pwnaui/pwnaui.service /etc/systemd/system/pwnaui.service
fi

# bt_gps_receiver service (if exists in system/services/)
if [ -f pwnaui-src/system/services/bt_gps_receiver.service ]; then
    cp pwnaui-src/system/services/bt_gps_receiver.service /etc/systemd/system/bt_gps_receiver.service
fi

# Enable services
systemctl enable pwnaui.service 2>/dev/null || true
systemctl enable bt_gps_receiver.service 2>/dev/null || true

# ---- Install caplets ----
if [ -d pwnaui-src/system/caplets ]; then
    echo -e "\e[32m### Installing PwnaUI caplets ###\e[0m"
    cp -r pwnaui-src/system/caplets/* /usr/local/share/bettercap/caplets/ 2>/dev/null || true
fi

# ---- Default config ----
if [ -f pwnaui-src/system/config/config.toml ]; then
    echo -e "\e[32m### Installing default config ###\e[0m"
    install -m 644 pwnaui-src/system/config/config.toml /etc/pwnaui/config.toml
fi

# ---- Cleanup ----
cd /home/pi
rm -rf pwnaui-src

echo -e "\e[32m### PwnaUI installation complete ###\e[0m"
