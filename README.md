# pwn-gen-bumchinz

Custom Pwnagotchi image builder by **Mr Bumchinz** - based on jayofelony's pwn-gen.

## What's Different

This fork includes:
- **PwnaUI** - Custom theme engine with native C renderer
- **Mode Toggle** - PiSugar button support for AUTO/MANU/AI mode switching
- **Nexmon Stability** - Auto-recovery plugin for WiFi crashes
- **17+ Themes** - pwnachu, pwnaflipper, hologram, mikugotchi, rick-sanchez, and more

## Build Requirements

Must build on Debian/Ubuntu Linux (or Docker):

```bash
sudo apt-get install -y make git quilt qemu-user-static debootstrap zerofree \
  libarchive-tools curl pigz arch-test qemu-utils qemu-system-arm qemu-user \
  gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf coreutils parted zip \
  dosfstools e2fsprogs libcap2-bin grep rsync xz-utils file bc gpg xxd \
  bmap-tools kmod
```

## Setup

```bash
# Clone this repo
git clone https://github.com/MrBumChinz/pwn-gen-bumchinz.git
cd pwn-gen-bumchinz

# Get pi-gen (the base image builder)
git clone https://github.com/RPI-Distro/pi-gen.git pi-gen-32bit
git clone -b arm64 https://github.com/RPI-Distro/pi-gen.git pi-gen-64bit
```

## Build

```bash
# Build 32-bit image (works on ALL Pi models: Zero, Zero W, 3, 4, 5)
make 32bit

# Build 64-bit image (Pi 3, 4, 5 only)
make 64bit
```

Output will be in `~/pwn-build/images/`:
- `pwnagotchi-bumchinz-32bit.img.xz`
- `pwnagotchi-bumchinz-64bit.img.xz`

## Build Stages

| Stage | Description |
|-------|-------------|
| 00-pre-pwn | Pre-installation hooks |
| 01-pwn-packages | System packages (aircrack-ng, python3, bluez, etc) |
| 02-libpcap | libpcap compilation |
| 03-bettercap-pwngrid | Go + bettercap + pwngrid |
| 04-nexmon | Monitor mode firmware |
| 05-install-pwnagotchi | Clone & install from **MrBumChinz/Pwnagotchi-Fork** |
| 06-hcxtools | Hashcat tools |
| 07-patches | Service files and configs |
| 08-pwnaui | **Custom theme engine** |
| 09-bumchinz-extras | **Mode toggle + stability plugins** |

## Docker Build (Windows/Mac)

If you don't have a Linux machine:

```bash
./pi-gen-32bit/build-docker.sh -c config-32bit
./pi-gen-64bit/build-docker.sh -c config-64bit
```

## Flash

Use any of:
- Raspberry Pi Imager
- balenaEtcher
- `dd` command

## Credits

- jayofelony - Original pwnagotchi maintainer & pwn-gen creator
- evilsocket - Original pwnagotchi creator
- RPi-Distro - pi-gen image builder
- Mr Bumchinz - This fork

## License

GPL-3.0