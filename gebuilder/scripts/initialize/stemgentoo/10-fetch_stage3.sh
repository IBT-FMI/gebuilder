#!/bin/bash

## Fetches the stage3-file from the gentoo webpage
##
## Note that this fetches an amd64 image and caches it, such that we
## do not download the same image twice

set -e

GENTOO_MIRROR="http://distfiles.gentoo.org/releases/amd64/autobuilds"
GENTOO_IMAGE_TEXTFILE="latest-stage3-amd64-openrc.txt"

debug "Fetching the newest gentoo stage3 url"
file="$(curl "${GENTOO_MIRROR}/${GENTOO_IMAGE_TEXTFILE}" | sed -n 's/\(\+*\.tar\.xz\).*/\1/p')"
filename="${file##*/}"
cachefile="${CACHE}/$filename"
debug "it is ${file}, downloading ${GENTOO_MIRROR}/${file} -> ${filename}:"
[ -f "${cachefile}" ] || curl -o "${cachefile}" "${GENTOO_MIRROR}/${file}"
rm "${CACHE}/stage3_latest.tar.xz" -f
ln -s "${cachefile}" "${CACHE}/stage3_latest.tar.xz"
