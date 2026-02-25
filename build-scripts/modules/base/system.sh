set -ouex pipefail

shopt -s nullglob

RELEASE="$(rpm -E %fedora)"
DATE=$(date +%Y%m%d)

sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' /usr/lib/systemd/system/bootc-fetch-apply-updates.service
sed -i 's|#AutomaticUpdatePolicy.*|AutomaticUpdatePolicy=stage|' /etc/rpm-ostreed.conf
sed -i 's|#LockLayering.*|LockLayering=true|' /etc/rpm-ostreed.conf

install -Dpm0644 -t /usr/share/plymouth/themes/spinner/ /ctx/assets/logos/watermark.png

sed -i '/^[[:space:]]*Defaults[[:space:]]\+timestamp_timeout[[:space:]]*=/d;$a Defaults timestamp_timeout=1' /etc/sudoers

curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo && \
echo "Default=true" | tee -a /etc/flatpak/remotes.d/flathub.flatpakrepo > /dev/null
flatpak remote-add --if-not-exists --system flathub /etc/flatpak/remotes.d/flathub.flatpakrepo
flatpak remote-modify --system --enable flathub

sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"Zena\"|
s|^ID=.*|ID=\"zena\"|
s|^VERSION=.*|VERSION=\"${RELEASE}.${DATE}\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"Zena ${RELEASE}.${DATE}\"|
s|^LOGO=.*|LOGO=\"cachyos\"|
s|^HOME_URL=.*|HOME_URL=\"https://github.com/Zena-Linux/Zena\"|
s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"https://github.com/Zena-Linux/Zena/issues\"|
s|^SUPPORT_URL=.*|SUPPORT_URL=\"https://github.com/Zena-Linux/Zena/issues\"|
s|^CPE_NAME=\".*\"|CPE_NAME=\"cpe:/o:zena-linux:zena\"|
s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"https://github.com/Zena-Linux/Zena\"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="zena"|

/^REDHAT_BUGZILLA_PRODUCT=/d
/^REDHAT_BUGZILLA_PRODUCT_VERSION=/d
/^REDHAT_SUPPORT_PRODUCT=/d
/^REDHAT_SUPPORT_PRODUCT_VERSION=/d
EOF
