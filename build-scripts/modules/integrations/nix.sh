set -ouex pipefail

shopt -s nullglob

dnf5 -y install nix nix-daemon

tar --create --verbose --preserve-permissions \
  --same-owner \
  --file /etc/nix-setup.tar \
  -C / nix

rm -rf /nix/* /nix/.[!.]*

system_services=(
  nix.mount
  nix-setup.service
  nix-daemon.service
)

systemctl enable "${system_services[@]}"
preset_file="/usr/lib/systemd/system-preset/01-zena.preset"
touch "$preset_file"

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done
