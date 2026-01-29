#!/bin/sh

if [ "$(id -u)" -ge 1000 ]; then
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

    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
    flatpak override --user --env=QT_QPA_PLATFORMTHEME=qt6ct
    flatpak override --user --env=QT_QPA_PLATFORMTHEME_QT6=qt6ct
fi
