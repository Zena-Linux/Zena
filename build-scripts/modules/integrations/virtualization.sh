set -ouex pipefail

shopt -s nullglob

dnf5 -y install qemu-kvm libvirt virt-install guestfs-tools waydroid

system_services=(
  libvirtd
)

systemctl enable "${system_services[@]}"
preset_file="/usr/lib/systemd/system-preset/01-zena.preset"
touch "$preset_file"

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done
