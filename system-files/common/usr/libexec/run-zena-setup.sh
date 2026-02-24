#!/bin/bash
set -euo pipefail

if [ -f /var/lib/zena-setup.done ]; then
    exit 0
fi

SETUP_USER="zena-setup"
NIRI_CMD="/usr/bin/niri"

if systemctl list-unit-files display-manager.service >/dev/null 2>&1; then
  systemctl mask --runtime display-manager.service
fi
if systemctl list-unit-files greetd.service >/dev/null 2>&1; then
  systemctl mask --runtime greetd.service
fi
if systemctl list-unit-files sddm.service >/dev/null 2>&1; then
  systemctl mask --runtime sddm.service
fi

/usr/libexec/zena-setup-daemon &

if ! id "$SETUP_USER" &>/dev/null; then
    useradd --system --shell /usr/bin/bash "$SETUP_USER"
fi

hostnamectl set-hostname zena --static
hostnamectl set-hostname "Zena" --pretty

chvt 5
systemctl stop getty@tty5.service
systemd-run --unit=zena-setup-gui --service-type=oneshot \
  --description="Zena Setup" \
  --property=StandardInput=tty \
  --property=TTYPath=/dev/tty5 \
  --property=User=root \
  --property=Before=greetd.service \
  --property=After=home.mount \
  bash -c '
    su -s /bin/sh zena-setup -c "RUST_LOG=error /usr/bin/niri --config /etc/zena-setup/niri.kdl > /dev/null 2>&1"; exit 0'

exit 0
