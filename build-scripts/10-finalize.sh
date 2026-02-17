#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

find /etc/yum.repos.d/ -maxdepth 1 -type f -name '*.repo' ! -name 'fedora.repo' ! -name 'fedora-updates.repo' ! -name 'fedora-updates-testing.repo' -exec rm -f {} +
rm -rf /tmp/* || true
dnf5 clean all

echo "::endgroup::"
