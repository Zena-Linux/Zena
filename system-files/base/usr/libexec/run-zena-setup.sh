#!/bin/bash
set -euo pipefail

SETUP_USER="zena-setup"
NIRI_CMD="/usr/bin/niri"

/usr/libexec/zena-setup-daemon &

if ! id "$SETUP_USER" &>/dev/null; then
    useradd --system --shell /usr/bin/bash "$SETUP_USER"
fi

hostnamectl set-hostname zena --static
hostnamectl set-hostname "Zena" --pretty

chvt 1
systemctl stop getty@tty1.service
systemd-run --unit=run-zena-setup-gui --service-type=oneshot \
  --description="Zena Setup" \
  --property=StandardInput=tty \
  --property=TTYPath=/dev/tty1 \
  --property=User=root \
  --property=Before=greetd.service \
  --property=After=home.mount \
  bash -c '
    exec su zena-setup -s /bin/bash -c "RUST_LOG=error exec /usr/bin/niri --config /etc/zena-setup/niri.kdl > /dev/null 2>&1"' || true

userdel -r zena-setup
