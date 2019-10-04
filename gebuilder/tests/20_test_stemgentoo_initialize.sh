#!/bin/bash

tmpdir="$(mktemp -d)"
pushd "${tmpdir}"
"$GEBUILDER_ENTRY" stemgentoo initialize
if [ "$?" -eq 0 ]
then
	RET=0
else
	RET=1
fi
