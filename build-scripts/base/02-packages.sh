#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

packages=(
  ############################
  # Hardware Support         #
  ############################
  steam-devices

  ############################
  # WIFI / WIRELESS FIRMWARE #
  ############################
  @networkmanager-submodules
  NetworkManager-wifi
  atheros-firmware
  brcmfmac-firmware
  iwlegacy-firmware
  iwlwifi-dvm-firmware
  iwlwifi-mvm-firmware
  mt7xxx-firmware
  nxpwireless-firmware
  realtek-firmware
  tiwilink-firmware

  ############################
  # AUDIO / SOUND FIRMWARE   #
  ############################
  alsa-firmware
  alsa-sof-firmware
  alsa-tools-firmware
  intel-audio-firmware

  ############################
  # SYSTEM / CORE UTILITIES  #
  ############################
  audit
  audispd-plugins
  cifs-utils
  firewalld
  fprintd
  fprintd-pam
  fuse
  fuse-devel
  man-pages
  systemd-container
  unzip
  whois
  inotify-tools
  gum
  xdg-user-dirs
  xdg-terminal-exec
  xdg-user-dirs-gtk
  zenity

  ############################
  # DESKTOP PORTALS          #
  ############################
  xdg-desktop-portal

  ############################
  # MOBILE / CAMERA SUPPORT #
  ############################
  gvfs-mtp
  gvfs-smb
  ifuse
  jmtpfs

  libcamera
  libcamera-v4l2
  libcamera-gstreamer
  libcamera-tools

  libimobiledevice

  ############################
  # AUDIO SYSTEM (PIPEWIRE)  #
  ############################
  pipewire
  pipewire-pulseaudio
  pipewire-alsa
  pipewire-jack-audio-connection-kit
  wireplumber
  pipewire-plugin-libcamera

  ############################
  # DEVTOOLS / CLI UTILITIES #
  ############################
  git
  yq
  distrobox

  ############################
  # DISPLAY + MULTIMEDIA     #
  ############################
  @multimedia
  ffmpeg
  gstreamer1-plugins-base
  gstreamer1-plugins-good
  gstreamer1-plugins-bad-free
  gstreamer1-plugins-bad-free-libs
  qt6-qtmultimedia
  lame-libs
  libjxl
  ffmpegthumbnailer
  glycin-libs
  glycin-gtk4-libs
  glycin-loaders
  glycin-thumbnailer
  gdk-pixbuf2
  libopenraw

  ############################
  # FONTS / LOCALE SUPPORT   #
  ############################
  @fonts
  glibc-all-langpacks
  jetbrains-mono-fonts
  fira-code-fonts
  dejavu-fonts-all
  nerd-fonts

  ############################
  # Performance              #
  ############################
  thermald
  power-profiles-daemon
  ksmtuned
  cachyos-ksm-settings
  cachyos-settings
  scx-scheds-git
  scx-tools-git
  scx-manager
  scxctl

  ############################
  # GRAPHICS / VULKAN        #
  ############################
  glx-utils
  mesa*
  *vulkan*

  ############################
  # PACKAGE MANAGERS         #
  ############################
  flatpak
  nix
  nix-daemon

  ############################
  # Dazzle                   #
  ############################
  plymouth
  plymouth-system-theme
)
dnf5 -y install "${packages[@]}" --exclude=scx-tools-nightly --exclude=scx-scheds-nightly


packages=(
  fastfetch

  bazaar
  firewall-config

  foot

  cups
  gutenprint-cups
  system-config-printer
  v4l2loopback

  tailscale
  cloudflare-warp
)
dnf5 -y install "${packages[@]}"

# Install install_weak_deps=false
packages=(
  niri
)
dnf5 -y install "${packages[@]}" --setopt=install_weak_deps=False

# Uninstall
packages=(
  console-login-helper-messages
  qemu-user-static*
  toolbox
)
dnf5 -y remove "${packages[@]}"

mv /usr/share/wayland-sessions/niri.desktop /usr/share/wayland-sessions/niri.desktop.disabled

curl -fsSL https://raw.githubusercontent.com/Zena-Linux/zix/refs/heads/main/zix | install -m 755 /dev/stdin /usr/local/bin/zix
curl -fsSL https://github.com/Zena-Linux/Zena-Setup/raw/refs/heads/main/zena-setup | install -m 755 /dev/stdin /usr/libexec/zena-setup
curl -fsSL https://github.com/Zena-Linux/Zena-Setup/raw/refs/heads/main/zena-setup-daemon | install -m 755 /dev/stdin /usr/libexec/zena-setup-daemon

PRELOAD_TMPDIR=$(mktemp -d)
git clone https://github.com/miguel-b-p/preload-ng.git "$PRELOAD_TMPDIR"
mkdir -p "/usr/local/sbin"
cp "$PRELOAD_TMPDIR/bin/preload"      "/usr/local/sbin/preload"
cp "$PRELOAD_TMPDIR/bin/preload.conf" "/etc/preload.conf"
chmod 755 "/usr/local/sbin/preload"
chmod 644 "/etc/preload.conf"
rm -rf "$PRELOAD_TMPDIR"

tar --create --verbose --preserve-permissions \
  --same-owner \
  --file /etc/nix-setup.tar \
  -C / nix

rm -rf /nix/* /nix/.[!.]*
echo "::endgroup::"
