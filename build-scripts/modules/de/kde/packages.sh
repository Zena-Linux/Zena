set -ouex pipefail

shopt -s nullglob

packages=(
  @kde-desktop
)
dnf5 -y install "${packages[@]}"
