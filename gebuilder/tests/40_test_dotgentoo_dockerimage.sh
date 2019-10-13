#!/bin/bash

RET=0

/etc/init.d/docker start
if [ ! "$?" -eq 0 ]
then
	error "Starting docker failed"
	RET=1
else

	"$GEBUILDER_ENTRY" "${DOTGENTOO}" docker_image
	if [ ! "$?" -eq 0 ]
	then
		error "Generating docker image for a .gentoo failed"
		RET=1
	else
		DOCKTAG="roots/${DOTGENTOO_ID}/registry/latest_docker_image"
		if [ ! -f "roots/${DOTGENTOO_ID}/registry/latest_docker_image"  -o ! -f "roots/${DOTGENTOO_ID}/registry/docker_images" ]
		then
			error "Docker image registry not generated"
			RET=1
		else
			docker run --rm true "$(<"${DOCKTAG}")" "/usr/bin/test" "-f" "/usr/include/gmp.h"
			if [ ! "$?" -eq 0 ]
			then
				error "Docker image does not include gmp.h, as it should"
			fi
		fi
	fi
fi
