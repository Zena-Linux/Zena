set -ouex pipefail

shopt -s nullglob

packages=(
  @kde-desktop
)
dnf5 -y install "${packages[@]}"

cp -r /usr/share/icons/cachyos.svg /usr/share/icons/hicolor/scalable/apps/start-here.svg
cp -r /usr/share/icons/cachyos.svg /usr/share/icons/hicolor/scalable/distributor-logo.svg
cp -r /usr/share/icons/cachyos.svg /usr/share/icons/hicolor/scalable/places/auralogo-symbolic.svg

