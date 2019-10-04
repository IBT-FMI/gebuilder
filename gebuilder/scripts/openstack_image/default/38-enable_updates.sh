#!/bin/bash

sed -i -e '/auto-sync = no/d' ${OPENSTACK_IMG_MNT}/etc/portage/repos.conf/gentoo
