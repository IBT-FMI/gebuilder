#!/bin/bash

## Various setup tasks
##
## Right now, this only includes unprotecting /etc/portage from config_protect
## since we do not want ._cfg* files to be placed there if we do --autounmask-*

debug "Adding CONFIG_PROTECT_MASK to make.conf to ignore /etc/portage/"

echo 'CONFIG_PROTECT_MASK="/etc/portage"' >> "${ROOT}/etc/portage/make.conf"

