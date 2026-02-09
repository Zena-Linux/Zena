#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

packages=(
  gnome-keyring
  gnome-keyring-pam

  greetd
  dms-greeter
  greetd-selinux

  dms
  dgop
  danksearch
  quickshell

  adw-gtk3-theme
  papirus-icon-theme

  xwayland-satellite

  cava
  matugen
  wl-clipboard
)
dnf5 -y install "${packages[@]}"

# Install install_weak_deps=false
packages=(
  niri
  mangowc
)

dnf5 -y install "${packages[@]}" --setopt=install_weak_deps=False

# Uninstall
packages=(
)
# dnf5 -y remove "${packages[@]}"

dconf update

sed -i 's|^Exec=.*|Exec=/usr/local/bin/bash -c "niri-session > /dev/null 2>\&1"|' \
  /usr/share/wayland-sessions/niri.desktop

sed -i 's|^Exec=.*|Exec=mango-session|' \
  /usr/share/wayland-sessions/mango.desktop

echo "::endgroup::"
