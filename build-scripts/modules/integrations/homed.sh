set -ouex pipefail

shopt -s nullglob

semodule -i /ctx/patches/homed-patch-01.pp

authselect select sssd with-systemd-homed with-faillock without-nullok
authselect apply-changes

system_services=(
  systemd-homed.service
)

systemctl enable "${system_services[@]}"

preset_file="/usr/lib/systemd/system-preset/01-zena.preset"
touch "$preset_file"

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done
