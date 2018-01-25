#!/bin/bash

#Where are all our scripts and stuff?
ROOT_DIR="$(realpath "$(dirname "$0")")"

#Where do we cache certain files?
CACHE="${ROOT_DIR}/cache/"

export NUM_CPU="$(grep -c processor /proc/cpuinfo)"

function debug(){
	echo "$@">&2
}

function error(){
	echo -e "\e[31m$@\e[0m">&2
}

function ok(){
	echo -e "\e[32m$@\e[0m">&2
}

declare -a _on_exit;
declare -a _on_error;


export -f debug error

function on_exit(){
	_on_exit=( "$1" "${_on_exit[@]}" )
}

function on_error(){
	_on_error=( "$1" "${_on_error[@]}" )
}

function error_pop(){
	_on_error=( "${_on_error[@]:1}" )
}

function exit_pop(){
	_on_exit=( "${_on_exit[@]:1}" )
}

function error_cleanup(){
	debug "Cleaning up after error"
	for func in "${_on_error[@]}"
	do
		debug "executing $func"
		eval "$func"
	done
}

function cleanup(){
	trap - ERR
	debug "Cleaning up"
	for func in "${_on_exit[@]}"
	do
		debug "executing $func"
		eval "$func"
	done
}

function clean_exit(){
	trap - ERR
	ok "Exiting"
	cleanup
	exit 0
}

function error_exit(){
	trap - ERR
	error "Exiting"
	cleanup
	error_cleanup
	exit 1;
}

function chksum(){
	sha256sum | tr -d -c '[a-z0-9]'
}

function normalize_deps(){
	sed 's/[[:blank:]]\+//;s/#.*//g;/^$/d;' | sort | uniq
}

function normalize_overlays(){
	"${ROOT_DIR}/utils/normalize_overlays.py" "$@"
}

function normalize_packagefiles(){
	type="$1"
	shift
	if [ -f "$1" ]
	then
		"${ROOT_DIR}/utils/normalize_packagefiles.py" "$type" "$@"
	fi
}

function get_dotgentoo_id(){
	normalize_dotgentoo "$@" | chksum
}

function get_ebuild(){
	find "$1" -name "*.ebuild" -print -quit 
}

function normalize_dotgentoo(){
	echo "#ebuild"
	cat "$(get_ebuild "$1")"
	echo "#overlays"
	olays=( "$1"/overlays/* )
	[ -f "${olays[0]}" ] && normalize_overlays ${olays[@]}
	for pkgfile in keywords mask unmask use
	do
		echo "#$pkgfile"
		normalize_packagefiles "$pkgfile" "$1/package.$pkgfile"/*
	done
}

function stdin_stderr_redirect() {
	exec 3>&1 4>&2 1> >(tee "$1") 2>&1
}

function stdin_stderr_restore() {
	exec 1>&3 3>&- 2>&4 4>&-
}

function exec_script_files(){
	debug "executing scripts $*"
	for script in "$@"
	do
		if [ -d "$script" ]
		then
			exec_script_files "$script/"*
		elif [ ! -x "$script" ]
		then
			continue;
		fi
		debug "Executing ${script#$ROOT_DIR/scripts/}"
		ensure_dir "${LOG_DIR}/"
		stdin_stderr_redirect "${LOG_DIR}/${script##*/}.log"
		if [ "${script##*\.}" == "chroot" ]
		then
			export -n ROOT
			cp "$script" "$ROOT/script.sh"
			echo "chrooting"
			chroot "$ROOT" "/script.sh"
			rm "${ROOT}/script.sh"
			echo "chroot done $RETVAL"
		else
			export ROOT
			. "$script"
		fi
		stdin_stderr_restore
	done

}

function load_config(){
	for file in "$1"/*.conf
	do
		if [ -f "$file" ]
		then
			source "$file"
		fi
	done
}

function exec_scripts(){
	STAGE="$1"
	MACHINE="$2"
	MACHINETYPE="${3:-default}"
	ROOT="$PWD/roots/$MACHINE/root"
	export STAGE MACHINE MACHINETYPE ROOT

	debug "Loading global configuration"
	load_config "${ROOT_DIR}/config/"
	debug "Loading configuration of machine $MACHINE"
	load_config "${ROOT}/../config/"
	debug "Executing $STAGE scripts for machine $MACHINE of type $MACHINETYPE"
	HOOKDIR="$ROOT/../hooks/$STAGE"
	PREDIR="${HOOKDIR}/pre"
	POSTDIR="${HOOKDIR}/post"
	if [ -d "$PREDIR" ]
	then
		exec_script_files "${PREDIR}/"*
	fi
	exec_script_files "$ROOT_DIR/scripts/$STAGE/$MACHINETYPE/"*
	if [ -d "$POSTDIR" ]
	then
		exec_script_files "${POSTDIR}/"*
	fi
}



function ensure_dir(){
	debug "Ensuring $1 is a directory"
	if [ ! -e "$1" ]
	then
		mkdir -p "$1"
	elif [ ! -d "$1" ]
	then
		error "$1 is not a directory"
		error_exit
	fi
}
set -o pipefail
set -E
trap error_exit ERR

