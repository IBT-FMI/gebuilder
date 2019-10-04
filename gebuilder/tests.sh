#!/bin/bash

source "$(dirname "$0")/utils/functions.sh"

msgs=()

function error(){
	msgs+=("ERROR: $*")
}

function ok(){
	msgs+=("OK: $*")
}

trap - ERR

if [ -z "${GEBUILDER_ENTRY+x}" ]
then
	GEBUILDER_ENTRY="${PWD}/exec.sh"
fi

declare TEST

for TEST in "${GEBUILDER_ROOT}/tests/"*.sh
do
	if [ ! -x "$TEST" ]
	then
		continue
	fi
	RET=1
	source "$TEST"
	if [ $RET -eq 0 ]
	then
		ok "$TEST ok"
	else
		error "$TEST failed"
	fi
done

for line in "${msgs[@]}"
do
	echo "$line"
done

clean_exit
