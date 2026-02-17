#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

KVER=$(ls /usr/lib/modules | head -n1)

echo "Building initramfs for kernel version: $KVER"

if [ ! -d "/usr/lib/modules/$KVER" ]; then
  echo "Error: modules missing for kernel $KVER"
  exit 1
fi

depmod -a "$KVER"
export DRACUT_NO_XATTR=1
/usr/bin/dracut \
  --no-hostonly \
  --kver "$KVER" \
  --reproducible \
  --zstd -v \
  --add ostree --add fido2 \
  -f "/usr/lib/modules/$KVER/initramfs.img"

chmod 0600 "/usr/lib/modules/$KVER/initramfs.img"

echo "::endgroup::"
