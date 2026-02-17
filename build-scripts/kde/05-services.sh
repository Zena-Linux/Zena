#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

system_services=(
)

user_services=(
)

mask_services=(
)

# systemctl enable "${system_services[@]}"
# systemctl mask "${mask_services[@]}"
# systemctl --global enable "${user_services[@]}"
#
# preset_file="/usr/lib/systemd/system-preset/01-zena.preset"
# touch "$preset_file"
#
# for service in "${system_services[@]}"; do
#   echo "enable $service" >> "$preset_file"
# done
#
# mkdir -p "/etc/systemd/user-preset/"
# preset_file="/etc/systemd/user-preset/01-zena.preset"
# touch "$preset_file"
#
# for service in "${user_services[@]}"; do
#   echo "enable $service" >> "$preset_file"
# done
#
# systemctl --global preset-all

echo "::endgroup::"
