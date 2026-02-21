set -ouex pipefail

shopt -s nullglob

packages=(
  @kde-desktop
)
dnf5 -y install "${packages[@]}"

# Replace default icons with Zena icons
TARGET_GLOB='/var/home/*/.config/plasma-org.kde.plasma.desktop-appletsrc'
TARGET_ICON='/usr/share/icons/cachyos.svg'

for file in $TARGET_GLOB; do
  [[ -f "$file" ]] || continue
  sed -i "s|^icon=.*|icon=${TARGET_ICON}|" "$file"
done
