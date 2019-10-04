#!/bin/bash

RET=0

"$GEBUILDER_ENTRY" "${DOTGENTOO}" initialize
if [ "$?" -eq 1 ]
then
	error "Second initialization of .gentoo succeeded where it should have failed"
	RET=1
fi

