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
    colors.kdl wpblur.kdl cursor.kdl layout.kdl outputs.kdl alttab.kdl binds.kdl

create_files "$HOME/.config/mango/dms" \
    colors.conf cursor.conf layout.conf outputs.conf binds.conf

if command -v flatpak >/dev/null; then
    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
fi
