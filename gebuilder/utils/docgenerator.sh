#!/bin/bash

parser="${0%docgenerator.sh}docparser.sh"

echo ".SH"
for file in "$1"/*
do
	command="${file#$1/}"
	if [[ "$command" == "common" ]]
	then
		continue
	fi
	for subfile in "$file"/*
	do
		category="${subfile#$file/}"
		echo ".SH $command ($category)"
		"$parser" "$subfile"
	done
done
