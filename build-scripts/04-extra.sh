#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

packages=(
  fish
  zsh

  fastfetch

  bazaar
  firewall-config

  foot
  nautilus
  nautilus-python

  cups
  gutenprint-cups
  system-config-printer
  v4l2loopback

  tailscale
  cloudflare-warp
)
dnf5 -y install "${packages[@]}"
dnf5 -y upgrade nautilus-python --releasever=44

# Install install_weak_deps=false
packages=(
)
# dnf5 -y install "${packages[@]}" --setopt=install_weak_deps=False

# Uninstall
packages=(
)
# dnf5 -y remove "${packages[@]}"

echo "::endgroup::"
