#!/bin/bash

source "$(dirname "$0")/utils/functions.sh"
trap - ERR

declare TEST

for TEST in "${ROOT_DIR}/tests/"*.sh
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
