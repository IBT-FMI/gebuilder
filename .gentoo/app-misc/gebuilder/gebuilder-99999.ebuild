# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Gentoo System and Image Builder"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="autoupdate btrfs docker"

DEPEND="
	>=app-shells/bash-4.2
	dev-python/python-glanceclient
	net-misc/rsync
	sys-apps/portage
	sys-apps/util-linux
	sys-boot/syslinux
	sys-fs/duperemove
	sys-kernel/dracut
"
RDEPEND="${DEPEND}
	docker? ( app-emulation/docker )
	btrfs? ( sys-fs/btrfs-progs )
	autoupdate? ( virtual/cron )
"

src_unpack() {
	mkdir "$S"
	cp -r -L "$DOTGENTOO_PACKAGE_ROOT/${PN}/"* -t "$S"
}

src_install() {
	insinto /usr/share/gebuilder
	doins -r utils config
	exeinto /usr/bin
	doexe gebuild
	insopts "-m0755"
	doins -r exec.sh scripts
	
	if use autoupdate; then
		einfo "Installing weekly cron job:"
		insinto /etc/cron.weekly
		doins ${FILESDIR}/gebuilder_global_update
	fi
}
