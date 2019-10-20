#!/bin/bash

RET=0

"$GEBUILDER_ENTRY" "${DOTGENTOO}" openstack_image
if [ ! "$?" -eq 0 ]
then
	error "Generating openstack image for a .gentoo failed"
	RET=1
else
	CLOUD_INIT=0
	LOGIN=0
	(
	qemu-system-x86_64 -hda "roots/${DOTGENTOO_ID}/openstack_images/"* -serial stdio -display none -nographic -snapshot -m 512 | while read line
	do
		case "$line" in
			"Cloud-init"*)
				CLOUD_INIT=1
			;;
			"login:"*)
				LOGIN=1
			*)
			;;
		esac
	done
	)&
	PID=$?
	sleep $((60*10))&
	wait -n
	if [ -e "/proc/${PID}" ]
	then
		error "The VM timed out"
		kill -s KILL "${PID}"
		RET=1
	fi

	if [ "${CLOUD_INIT}" -eq 0 ]
	then
		error "Cloud Init was not called"
		RET=1
	fi

	if [ "${LOGIN}" -eq 0 ]
	then
		error "No login screen reached"
		RET=1
	fi
fi
