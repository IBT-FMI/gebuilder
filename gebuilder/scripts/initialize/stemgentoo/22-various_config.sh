#!/bin/bash

debug "Adding CONFIG_PROTECT_MASK to make.conf to ignore /etc/portage/"

echo 'CONFIG_PROTECT_MASK="/etc/portage"' >> "${ROOT}/etc/portage/make.conf"

