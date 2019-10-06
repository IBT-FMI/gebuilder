#!/bin/bash

## Bind mount the stemgentoo main portage directory to the childs root
##
## This allows us to not sync the portage tree multiple times, which is
## considered bad behaviour

mount -o bind roots/stemgentoo/root/usr/portage/ "${ROOT}"/usr/portage
on_exit "umount '${ROOT}/usr/portage'"
