#!/bin/bash

"$GEBUILDER_ENTRY" stemgentoo update
if [ "$?" -eq 0 ]
then
	RET=0
else
	RET=1
fi
