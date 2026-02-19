#!/usr/bin/env bash
set -euo pipefail

echo "=== Building variant: $FLAVOR ==="

modules=()

case "$FLAVOR" in
  zena)
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
    )
    ;;
  zena-nvidia)
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
    )
    ;;
  zena-kde)
    modules=(
      "base.dnf"
      "base.kernel"
      "base.packages"
      "base.system"
      "base.services"
      "de.kde.packages"
      "integrations.homed"
      "integrations.nix"
    )
    ;;
  zena-kde-nvidia)
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
