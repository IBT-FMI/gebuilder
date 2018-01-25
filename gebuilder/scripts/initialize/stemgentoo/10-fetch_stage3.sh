#!/bin/bash
set -e

GENTOO_MIRROR="http://distfiles.gentoo.org/releases/amd64/autobuilds"

debug "Fetching the newest gentoo stage3 url"
file="$(curl "${GENTOO_MIRROR}/latest-stage3-amd64.txt" | sed -n 's/\(\+*\.tar\.xz\).*/\1/p')"
filename="${file##*/}"
cachefile="${CACHE}/$filename"
debug "it is ${file}, downloading ${GENTOO_MIRROR}/${file} -> ${filename}:"
[ -f "${cachefile}" ] || curl -o "${cachefile}" "${GENTOO_MIRROR}/${file}"
rm "${CACHE}/stage3_latest.tar.xz" -f
ln -s "${cachefile}" "${CACHE}/stage3_latest.tar.xz"
