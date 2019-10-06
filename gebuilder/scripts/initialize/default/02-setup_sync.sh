#!/bin/bash

PORTDIR="$(get_portdir "${ROOT}" "")"
mkdir -p "${ROOT}/etc/portage/repos.conf"
cat <<-EOF > "${ROOT}/etc/portage/repos.conf/gentoo"
[DEFAULT]
main-repo = gentoo

[gentoo]
location = ${PORTDIR}
sync-type = rsync
sync-uri = rsync://rsync.gentoo.org/gentoo-portage
auto-sync = no
EOF
