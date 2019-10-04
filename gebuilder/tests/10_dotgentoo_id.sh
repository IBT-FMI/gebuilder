#!/bin/bash

ID1="$(get_dotgentoo_id "${GEBUILDER_ROOT}/tests/dotgentoos/.gentoo1")"
ID2="$(get_dotgentoo_id "${GEBUILDER_ROOT}/tests/dotgentoos/.gentoo2")"
ID3="$(get_dotgentoo_id "${GEBUILDER_ROOT}/tests/dotgentoos/.gentoo3")"

if [ "$ID1" != "$ID2" ]
then
	error "IDs of two should-be identical .gentoos do not match"
	RET=1
elif [ "$ID1" == "$ID3" ]
then
	error "IDs of two should-be different .gentoos are the same"
	RET=1
else
	RET=0
fi

