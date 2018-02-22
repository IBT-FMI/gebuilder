#!/bin/bash

OPENSTACK_IMG_MNT="${ROOT}/../mnt"

ensure_dir "${OPENSTACK_IMG_MNT}"

debug "Monting the image on ${OPENSTACK_IMG_MNT}"
mount -t "${OPENSTACK_FILESYSTEM}" "${OPENSTACK_IMG_LODEV}p1" "${OPENSTACK_IMG_MNT}"
on_exit_save
on_exit "umount ${OPENSTACK_IMG_MNT}"
