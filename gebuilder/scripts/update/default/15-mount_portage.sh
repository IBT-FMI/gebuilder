#!/bin/bash

mount -o bind /var/lib/gebuilder/roots/stemgentoo/root/usr/portage/ "${ROOT}"/usr/portage
on_exit "umount '${ROOT}/usr/portage'"
