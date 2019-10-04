#!/bin/bash

source "$(dirname "$0")/utils/functions.sh"
MACHINETYPE="$3"
declare ID
if [ "$1" == "stemgentoo" ]
then
	ID="stemgentoo"
	MACHINETYPE="stemgentoo"
else
	ID="$(get_dotgentoo_id "$1")"
fi

if [ "$2" == "initialize" -a "$MACHINETYPE" != "stemgentoo" ]
then
	ensure_dir "/var/lib/gebuilder/roots/$ID"
	cp -r "$1" "/var/lib/gebuilder/"
fi

exec_scripts "$2" "$ID" "$MACHINETYPE"
ok "Finished succesfully"
trap - ERR
cleanup
CHAINFILE="/var/lib/gebuilder/roots/$ID/hooks/$2/chain"
echo "$CHAINFILE"
if [ -f "${CHAINFILE}" ]
then
	while read action
	do
		debug "Chaining action $action to $2 on machine $1 of type $MACHINETYPE"
		"$0" "$1" "$action" "$3"
	done < "${CHAINFILE}"
fi
