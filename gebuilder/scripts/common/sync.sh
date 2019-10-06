#!/bin/bash

## Synchronize all the portage repos

for VCS in "cvs" "git" "mercurial" "subversion"; do
	echo "Checking if repos need ${VCS}."
	grep -qr ${VCS} /etc/portage/repos.conf/ &&
		echo "Apparently ${VCS} is needed, emerging..." &&
		emerge dev-vcs/${VCS}
done

emaint sync -a
