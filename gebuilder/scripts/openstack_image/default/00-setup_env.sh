#!/bin/bash

OPENSTACK_IMAGE_DIR="${ROOT}/../openstack_images/"
OPENSTACK_IMAGE_NAME="$(date "+%Y-%m-%d")"
ensure_dir "${OPENSTACK_IMAGE_DIR}"
OPENSTACK_IMAGE="${OPENSTACK_IMAGE_DIR}/${OPENSTACK_IMAGE_NAME}"

export OPENSTACK_PKGS="gentoo-sources dropbear syslog-ng cloud-init dhcpcd"

debug "Calculating disk usage..."
ROOT_SIZE="$(du -csb "${ROOT}" | awk '/total$/{print $1}')"
OPENSTACK_IMAGE_SIZE=$(((500+ROOT_SIZE/1000/1000)/1000+4))
debug "Got ${ROOT_SIZE} bytes, rounding off to ${OPENSTACK_IMAGE_SIZE} Gigabytes"
