#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

packages=(
  xdg-desktop-portal-gtk
  xdg-desktop-portal-gnome

  gnome-keyring
  gnome-keyring-pam

  greetd
  dms-greeter
  greetd-selinux

  dms
  dgop
  danksearch
  quickshell
  gtk4-layer-shell

  adw-gtk3-theme
  papirus-icon-theme

  xwayland-satellite

  cava
  wl-clipboard
)
dnf5 -y install "${packages[@]}" --exclude=matugen

# Install install_weak_deps=false
packages=(
  mangowc
)

dnf5 -y install "${packages[@]}" --setopt=install_weak_deps=False
dnf5 -y install matugen --releasever=44 --disablerepo='*copr*'

# Uninstall
packages=(
)
# dnf5 -y remove "${packages[@]}"

XDG_EXT_TMPDIR="$(mktemp -d)"
curl -fsSLo - "$(curl -fsSL https://api.github.com/repos/tulilirockz/xdg-terminal-exec-nautilus/releases/latest | jq -rc .tarball_url)" | tar -xzvf - -C "${XDG_EXT_TMPDIR}"
install -Dpm0644 -t "/usr/share/nautilus-python/extensions/" "${XDG_EXT_TMPDIR}"/*/xdg-terminal-exec-nautilus.py
rm -rf "${XDG_EXT_TMPDIR}"

dconf update
mv /usr/share/wayland-sessions/niri.desktop.disabled /usr/share/wayland-sessions/niri.desktop
sed -i 's|^Exec=.*|Exec=bash -c "niri-session > /dev/null 2>\&1"|' \
  /usr/share/wayland-sessions/niri.desktop

sed -i 's|^Exec=.*|Exec=bash -c "mango -s mango-session > /dev/null 2>\&1"|' \
  /usr/share/wayland-sessions/mango.desktop

echo "::endgroup::"
