#!/bin/bash

if [ ! "$(id -u)" -eq 0 ]
then
	echo "Need to be root to execute the testsuite"
	echo "Exiting"
	exit 2
fi

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

exitcode=0

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
		exitcode=1
	fi
done

for line in "${msgs[@]}"
do
	echo "$line"
done

cleanup
exit $exitcode
