#!/usr/bin/env bash
set -euo pipefail

echo "=== Building variant: $FLAVOR ==="

modules=()

case "$FLAVOR" in
  zena)
    cp -avf "/ctx/system-files/twm/." /
    modules=(
      "base.dnf"
      "base.kernel"
      "base.packages"
      "base.system"
      "base.services"
      "de.wm.packages"
      "de.wm.services"
      "integrations.homed"
      "integrations.nix"
      "sign"
      "initramfs"
    )
    ;;
  zena-nvidia)
    cp -avf "/ctx/system-files/twm/." /
    cp -avf "/ctx/system-files/nvidia/." /
    modules=(
      "base.dnf"
      "base.kernel"
      "base.packages"
      "base.system"
      "base.services"
      "de.wm.packages"
      "de.wm.services"
      "integrations.homed"
      "integrations.nix"
      "integrations.nvidia"
      "sign"
      "initramfs"
    )
    ;;
  zena-kde)
    # cp -avf "/ctx/system-files/kde/." /
    modules=(
      "base.dnf"
      "base.kernel"
      "base.packages"
      "base.system"
      "base.services"
      "de.kde.packages"
      "integrations.homed"
      "integrations.nix"
      "sign"
      "initramfs"
    )
    ;;
  zena-kde-nvidia)
    # cp -avf "/ctx/system-files/kde/." /
    cp -avf "/ctx/system-files/nvidia/." /
    modules=(
      "base.dnf"
      "base.kernel"
      "base.packages"
      "base.system"
      "base.services"
      "de.kde.packages"
      "integrations.homed"
      "integrations.nix"
      "integrations.nvidia"
      "sign"
      "initramfs"
    )
    ;;
  *)
    echo "Unknown variant: $FLAVOR"
    exit 1
    ;;
esac

for mod in "${modules[@]}"; do
    path="/ctx/modules/${mod//./\/}.sh"
    echo "::group:: === $(basename "$path") ==="
    bash "$path"
    echo "::endgroup::"
done

echo "==> Build complete: $FLAVOR"
