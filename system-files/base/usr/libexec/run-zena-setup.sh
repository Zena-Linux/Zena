#!/bin/bash
set -euo pipefail

SETUP_USER="zena-setup"
NIRI_CMD="/usr/bin/niri"

/usr/libexec/zena-setup-daemon &

if ! id "$SETUP_USER" &>/dev/null; then
    useradd --system --shell /usr/bin/bash "$SETUP_USER"
fi

touch /var/lib/zena-setup.done
runuser -u "$SETUP_USER" -- "$NIRI_CMD /etc/zena-setup/niri.kdl"
