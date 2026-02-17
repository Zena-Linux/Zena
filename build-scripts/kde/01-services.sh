#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

system_services=(
  greetd.service
)

user_services=(
)

mask_services=(
  sddm.service
)

systemctl enable "${system_services[@]}"
systemctl mask "${mask_services[@]}"

preset_file="/usr/lib/systemd/system-preset/01-zena.preset"
touch "$preset_file"

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done

for service in "${mask_services[@]}"; do
  echo "disable $service" >> "$preset_file"
done

echo "::endgroup::"
