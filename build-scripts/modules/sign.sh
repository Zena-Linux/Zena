set -ouex pipefail

shopt -s nullglob

KVER=$(ls /usr/lib/modules | head -n1)
KIMAGE="/usr/lib/modules/$KVER/vmlinuz"
SIGN_DIR="/secureboot"

dnf5 -y install sbsigntools

sbsign \
  --key "$SIGN_DIR/MOK.key" \
  --cert "$SIGN_DIR/MOK.pem" \
  --output "${KIMAGE}.signed" \
  "$KIMAGE"
mv "${KIMAGE}.signed" "$KIMAGE"

find "/lib/modules/$KVER" -type f -name '*.ko.xz' -print0 | while IFS= read -r -d '' comp; do
  uncompressed="${comp%.xz}"

  if xz -d --keep "$comp"; then
    echo "Decompressed $comp → $uncompressed"
  else
    echo "Warning: failed to decompress $comp, skipping"
    continue
  fi

  /usr/src/kernels/"$KVER"/scripts/sign-file \
    sha512 "$SIGN_DIR/MOK.key" "$SIGN_DIR/MOK.pem" "$uncompressed" || true
  rm -f "$comp"

  if xz -z "$uncompressed"; then
    echo "Recompressed and signed $uncompressed - ${uncompressed}.xz"
  else
    echo "Warning: failed to recompress $uncompressed"
  fi
done

rm -f "$SIGN_DIR/MOK.key"
