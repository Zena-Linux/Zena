#!/bin/bash
set -euo pipefail

TARGET_GLOB='/var/home/*/.config/plasma-org.kde.plasma.desktop-appletsrc'
TARGET_ICON='/usr/share/icons/zena.svg'

for file in $TARGET_GLOB; do
  [[ -f "$file" ]] || continue
  sed -i "s|^icon=.*|icon=${TARGET_ICON}|" "$file"
done
