#!/bin/bash

debug "Syncing ${ROOT} with the directory ${OPENSTACK_IMG_MNT}"
rsync -a "${ROOT}/" "${OPENSTACK_IMG_MNT}/"
