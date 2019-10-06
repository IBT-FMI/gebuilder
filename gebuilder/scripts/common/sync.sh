#!/bin/bash

for VCS in "cvs" "git" "mercurial" "subversion"; do
	echo "Checking if repos need ${VCS}."
	grep -qr ${VCS} /etc/portage/repos.conf/ &&
		echo "Apparently ${VCS} is needed, emerging..." &&
		emerge dev-vcs/${VCS}
done

sed -i -e 's/auto-sync = yes/auto-sync = no/g' /etc/portage/repos.conf/gentoo
emaint sync -a
sed -i -e 's/auto-sync = no/auto-sync = yes/g' /etc/portage/repos.conf/gentoo
