#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

packages=(
  plasma-desktop
  plasma-login-manager
  kcm-plasmalogin
  kwalletmanager
)
dnf5 -y install "${packages[@]}" --releasever=44

# Install install_weak_deps=false
packages=(
)

# dnf5 -y install "${packages[@]}" --setopt=install_weak_deps=False

# Uninstall
packages=(
)
# dnf5 -y remove "${packages[@]}"

echo "::endgroup::"
