#!/bin/bash

declare -a env_array
declare -a desc_array

steps=1

for file in "$1"/*
do
	if [ -f "${file}" ]; then
		input="$file"

		output_content=""
		output="$(printf ".IP %d.\n.IR %s :\n" ${steps} "${file#$1/}")"

		while IFS= read -r line
		do
			if [ "${line:0:2}" = "##" ]; then

				if [ "${line:3:1}" = "@" ]; then
					env_array+=("${line:4}")
				else
					if [ -z "${line:3}" ]
					then
						output+="\n.PP"
					else
						output+="\n${line:3}"
					fi
				fi

			fi
		done < "$input"

		desc_array+=("${output}")
	fi
	steps=$((steps + 1))
done

echo ".SS Environment Variables"

for env_var in "${env_array[@]}"
do
	string_array=($env_var)
	echo -e ".TP\n.B ${string_array[0]}\n${string_array[@]:1}"
done

echo ".SS Steps"

for desc_var in "${desc_array[@]}"
do
	echo -e "$desc_var"
done
