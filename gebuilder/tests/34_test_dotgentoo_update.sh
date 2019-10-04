#!/bin/bash

RET=0

"$GEBUILDER_ENTRY" "${DOTGENTOO}" update
if [ "$?" -eq 0 ]
then
	error "Updating of .gentoo failed"
	RET=1
fi

