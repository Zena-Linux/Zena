set -ouex pipefail

shopt -s nullglob

semodule -i /ctx/patches/homed-patch-01.pp

auth_features=(
  with-systemd-homed
  with-faillock
  without-nullok
)

if [[ "${IMAGE:-}" == zena-kde* ]]; then
  auth_profile="local"
else
  auth_profile="sssd"
fi

if ! authselect select "$auth_profile" "${auth_features[@]}"; then
  echo "ERROR: authselect profile selection failed" >&2
  echo "  image: ${IMAGE:-<unset>}" >&2
  echo "  profile: $auth_profile" >&2
  echo "  features: ${auth_features[*]}" >&2
  exit 1
fi

if ! authselect apply-changes; then
  echo "ERROR: authselect apply-changes failed" >&2
  echo "  image: ${IMAGE:-<unset>}" >&2
  echo "  profile: $auth_profile" >&2
  echo "  features: ${auth_features[*]}" >&2
  exit 1
fi

system_services=(
  systemd-homed.service
)

systemctl enable "${system_services[@]}"

preset_file="/usr/lib/systemd/system-preset/01-zena.preset"
touch "$preset_file"

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done
