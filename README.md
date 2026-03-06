# pwn-gen-bumchinz

Custom Pwnagotchi image builder by **Mr Bumchinz** - based on [jayofelony's pwn-gen](https://github.com/jayofelony/pwn-gen).

Produces flashable `.img.xz` files for Raspberry Pi SD cards.

## What's Different

This fork includes:
- **PwnaUI** - Native C theme engine with 17+ themes (pwnachu, pwnaflipper, hologram, mikugotchi, rick-sanchez, and more)
- **WebUI** - Browser-based control at `http://<device>.local/crackcity.html`
- **Bluetooth GPS** - Wardriving support via phone GPS over Bluetooth
- **Hostname/mDNS Sync** - Device name from config auto-syncs to system hostname
- **Mode Toggle** - PiSugar button support for AUTO/MANU/AI mode switching
- **Nexmon Stability** - Auto-recovery plugin for WiFi crashes

## Build Requirements

Must build on Debian/Ubuntu Linux (x86_64). Requires ~20GB free disk space.

```bash
sudo apt-get install -y make git quilt qemu-user-static debootstrap zerofree \
  libarchive-tools curl pigz arch-test qemu-utils qemu-system-arm qemu-user \
  gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf coreutils parted zip \
  dosfstools e2fsprogs libcap2-bin grep rsync xz-utils file bc gpg xxd \
  bmap-tools kmod
```

## Setup & Build

```bash
# Clone this repo
git clone https://github.com/MrBumChinz/pwn-gen-bumchinz.git
cd pwn-gen-bumchinz

# Build 32-bit image (works on ALL Pi models: Zero, Zero W, 3, 4, 5)
make 32bit

# Build 64-bit image (Pi 3, 4, 5 only - better performance)
make 64bit
```

The Makefile will automatically clone pi-gen if not present. Output will be in `~/images/`:
- `pwnagotchi-bumchinz-32bit.img.xz`
- `pwnagotchi-bumchinz-64bit.img.xz`

## Build Stages

| Stage | Description |
|-------|-------------|
| 00-pre-pwn | Pre-installation hooks |
| 01-pwn-packages | System packages + Rust (aircrack-ng, python3, bluez, etc) |
| 02-libpcap | libpcap 1.9 from source |
| 03-bettercap-pwngrid | Go + bettercap + pwngrid |
| 04-nexmon | Nexmon monitor mode firmware |
| 05-install-pwnagotchi | Clone & install from **MrBumChinz/Pwnagotchi-Fork** |
| 06-hcxtools | hcxpcapngtool for hashcat conversion |
| 07-patches | Service files, configs, boot settings |
| 08-pwnaui | **PwnaUI native renderer + WebUI + BT GPS + themes** |
| 09-bumchinz-extras | **Mode toggle + nexmon stability plugin** |

## GitHub Actions (CI)

Builds run automatically on tag push (`v*`) or manual dispatch via the Actions tab.
Artifacts are uploaded and releases are created automatically.

## Docker Build (Alternative)

If you don't have a native Linux machine:

```bash
# After make setup (or manually clone pi-gen)
./pi-gen-32bit/build-docker.sh -c config-32bit
./pi-gen-64bit/build-docker.sh -c config-64bit
```

## Flash

Use any of:
- [Raspberry Pi Imager](https://www.raspberrypi.com/software/) (recommended)
- [balenaEtcher](https://www.balena.io/etcher/)
- `xzcat image.img.xz | sudo dd of=/dev/sdX bs=4M status=progress`

Default credentials: `pi` / `raspberry`

## Credits

- [jayofelony](https://github.com/jayofelony) - Original pwnagotchi maintainer & pwn-gen creator
- [evilsocket](https://github.com/evilsocket) - Original pwnagotchi creator
- [RPi-Distro](https://github.com/RPi-Distro/pi-gen) - pi-gen image builder
- **Mr Bumchinz** - This fork

## License

GPL-3.0