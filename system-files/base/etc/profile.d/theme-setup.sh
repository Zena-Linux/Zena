#!/bin/sh

if [ "$(id -u)" -ge 1000 ]; then
    cp -a -n /etc/skel/. "$HOME/"
    DMS="$HOME/.config/niri/dms"

    mkdir -p "$DMS"

    files="
    colors.kdl
    wpblur.kdl
    cursor.kdl
    outputs.kdl
    layout.kdl
    alttab.kdl
    binds.kdl
    "

    for file in $files; do
        if [ ! -e "$DMS/$file" ]; then
            touch "$DMS/$file"
        fi
    done

    DMS="$HOME/.config/mango/dms"

    mkdir -p "$DMS"

    files="
    colors.kdl
    layout.kdl
    outputs.kdl
    binds.kdl
    "

    for file in $files; do
        if [ ! -e "$DMS/$file" ]; then
            touch "$DMS/$file"
        fi
    done

    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
fi
