#!/bin/bash

RET=0

"$GEBUILDER_ENTRY" "${DOTGENTOO}" openstack_image
if [ ! "$?" -eq 0 ]
then
	error "Generating openstack image for a .gentoo failed"
	RET=1
fi
