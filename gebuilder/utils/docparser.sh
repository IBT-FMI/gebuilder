#!/bin/bash

declare -a env_array
declare -a desc_array

for file in $1*
do
    if [ -f "${file}" ]; then
        input=$file
        
        output_content=""
        output=$(echo "file: \e[1m${file##*/}\e[0m\n")

        while IFS= read -r line
        do
            if [ "${line:0:2}" = "##" ]; then

                if [ "${line:3:1}" = "@" ]; then
                    env_array+=("${line:4}")    
                else
                    output_content+=$(echo "${line:3}\n")
                
                fi
                
            fi
        done < "$input"

        if [ "${output_content}" != "" ]; then
            output+=$(echo -e "\e[3m${output_content}\e[0m")      
            desc_array+=("${output}")
        fi        
    fi
done

echo -e "\e[92m---------- Enviroment variables ----------\e[39m"

for env_var in "${env_array[@]}"
do
    string_array=($env_var)
    echo -e "\e[92m\e[1m${string_array[0]}\e[0m\e[39m ${string_array[@]:1}"
done

echo ""

for desc_var in "${desc_array[@]}"
do
    echo -e "$desc_var"
done


