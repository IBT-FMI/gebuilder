#!/bin/bash

RET=0

DOTGENTOO="${GEBUILDER_ROOT}/tests/dotgentoos/.gentoo"

DOTGENTOO_ID="$(get_dotgentoo_id "${DOTGENTOO}")"
"$GEBUILDER_ENTRY" "${DOTGENTOO}" initialize
if [ "$?" -eq 0 ]
then
	error "Initialization of .gentoo failed"
	RET=1
fi

if [ "roots/${DOTGENTOO_ID}/root/usr/include/gmp.h" ]
then
	error "GMP dependency not pulled in"
	RET=1
fi
