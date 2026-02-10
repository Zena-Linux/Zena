#!/bin/bash

set -e

if [ "$(id -u)" -lt 1000 ]; then
    exit 0
fi

# Copy skeleton
cp -a -n /etc/skel/. "$HOME/"

create_files() {
    target="$1"
    shift
    mkdir -p "$target"
    for file in "$@"; do
        [ -e "$target/$file" ] || touch "$target/$file"
    done
}

create_files "$HOME/.config/niri/dms" \
    colors.kdl wpblur.kdl cursor.kdl outputs.kdl layout.kdl alttab.kdl binds.kdl

create_files "$HOME/.config/mango/dms" \
    colors.kdl layout.kdl outputs.kdl binds.kdl

FOOT_DIR="$HOME/.config/foot"
FOOT_CONFIG="$FOOT_DIR/foot.ini"
DMS_CONFIG="$FOOT_DIR/dank-colors.ini"

if [ -f "$FOOT_CONFIG" ]; then
    if sed --version >/dev/null 2>&1; then
        sed -i "s|<USERNAME>|$USER|g" "$FOOT_CONFIG"
    else
        sed -i '' "s|<USERNAME>|$USER|g" "$FOOT_CONFIG"
    fi
fi

[ -e "$DMS_CONFIG" ] || touch "$DMS_CONFIG"

if command -v flatpak >/dev/null; then
    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
fi

