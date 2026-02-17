#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

packages=(
  @kde-desktop
  greetd
  greetd-selinux
  dms-greeter
)
dnf5 -y install "${packages[@]}"

# Install install_weak_deps=false
packages=(
)

# dnf5 -y install "${packages[@]}" --setopt=install_weak_deps=False

# Uninstall
packages=(
)
# dnf5 -y remove "${packages[@]}"

echo "::endgroup::"
