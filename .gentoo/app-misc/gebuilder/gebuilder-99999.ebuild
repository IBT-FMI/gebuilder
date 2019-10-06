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
	sys-devel/m4
"
RDEPEND="${DEPEND}
	sys-process/lsof
	docker? ( >=app-emulation/docker-18.05.0 )
	btrfs? ( sys-fs/btrfs-progs )
	autoupdate? ( virtual/cron )
"

src_unpack() {
	mkdir "$S"
	cp -r -L "$DOTGENTOO_PACKAGE_ROOT/"* -t "$S"
}

src_compile(){
	emake
}

src_install() {
	default
	if use autoupdate; then
		einfo "Installing weekly cron job:"
		insinto /etc/cron.weekly
		doins ${FILESDIR}/gebuilder_global_update
	fi
}
