#!/bin/sh

if [ "$(id -u)" -lt 1000 ]; then
    exit 0
fi

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
