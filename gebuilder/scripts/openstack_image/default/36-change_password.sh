#!/bin/bash

debug "Setting root-password to $OPENSTACK_ROOT_PASSWORD"
chpasswd -R "${ROOT}" <<< "root:$OPENSTACK_ROOT_PASSWORD"

