#!/bin/sh

if [[ $UID -ne 0 && -z "${GEBUILD_NONROOT+x}" ]]
then
	echo "Sorry, gebuild needs to be executed by root to work properly.">&2
	echo "You can override this by setting GEBUILD_NONROOT=1">&2
	exit 1
fi

if [[ ! -e "IMAGESDIR" ]]
then
	mkdir "IMAGESDIR"
fi
cd "IMAGESDIR"

export CACHE="CACHEDIR"
exec "GEBUILDER_ROOT/exec.sh" "$@"
