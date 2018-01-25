#!/bin/bash

for file in dev dev/pts proc sys var/tmp/portage tmp
do
	on_exit "umount \"${ROOT}/$file\""
done

pushd "${ROOT}"
debug "bind-mount /dev to dev/"
mount --bind /dev/ dev
debug "mount proc/"
mount -t proc none proc
debug "mount sys/"
mount -t sysfs none sys
debug "mount devpts with gid=5 for glibc[-suid] at /dev/pts/"
mount -t devpts -o gid=5 none dev/pts/
debug "mount tmpfd on /var/tmp/portage"
mkdir -p var/tmp/portage
mount -t tmpfs -o size=6G none var/tmp/portage
debug "mounting tmpfs on /tmp/"
mount -t tmpfs -o size=1G none tmp
popd
