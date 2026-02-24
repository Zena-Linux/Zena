set -ouex pipefail

shopt -s nullglob

packages=(
  @kde-desktop
)
dnf5 -y install "${packages[@]}"

# Replace default icon with Zena icon
TARGET_ICON='/usr/share/icons/hicolor/scalable/apps/start-here.svg'
ZENA_ICON='/usr/share/icons/cachyos.svg'

ln -sf "$ZENA_ICON" "$TARGET_ICON"