#!/bin/bash

"$GEBUILDER_ENTRY" stemgentoo initialize
if [ "$?" -eq 0 ]
then
	RET=1
else
	RET=0
fi
