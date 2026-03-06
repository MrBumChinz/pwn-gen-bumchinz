#!/bin/bash -e

cd /home/pi
echo -e "\e[32m### Manually installing lgpio from source ###\e[0m"
wget http://abyz.me.uk/lg/lg.zip
unzip lg.zip
cd lg
make
make install

cd /home/pi
rm -r lg.zip lg/

echo -e "\e[32m### lgpio installed (no Python pwnagotchi - PwnaUI is C-only) ###\e[0m"