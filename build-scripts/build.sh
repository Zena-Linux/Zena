#!/usr/bin/env bash
set -euo pipefail

echo "=== Building: $IMAGE ==="

modules=(
  "base.dnf"
  "base.kernel"
  "base.packages"
  "base.system"
  "base.services"
)

case "$IMAGE" in
  zena)
    cp -avf "/ctx/system-files/twm/." /
    modules+=(
      "de.wm.packages"
      "de.wm.services"
    )
    ;;
  zena-nvidia)
    cp -avf "/ctx/system-files/twm/." /
    cp -avf "/ctx/system-files/nvidia/." /
    modules+=(
      "de.wm.packages"
      "de.wm.services"
      "integrations.nvidia"
    )
    ;;
  zena-kde)
    # cp -avf "/ctx/system-files/kde/." /
    modules+=(
      "de.kde.packages"
    )
    ;;
  zena-kde-nvidia)
    # cp -avf "/ctx/system-files/kde/." /
    cp -avf "/ctx/system-files/nvidia/." /
    modules+=(
      "de.kde.packages"
      "integrations.nvidia"
    )
    ;;
  *)
    echo "Unknown image: $IMAGE"
    exit 1
    ;;
esac

modules+=(
  "integrations.homed"
  "integrations.nix"
  "sign"
  "initramfs"
)

for mod in "${modules[@]}"; do
    path="/ctx/modules/${mod//./\/}.sh"
    echo "::group:: === $(basename "$path") ==="
    bash "$path"
    echo "::endgroup::"
done

echo "==> Build complete: $IMAGE"
