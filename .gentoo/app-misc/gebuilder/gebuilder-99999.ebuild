# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo System and Image Builder"
HOMEPAGE="https://github.com/IBT-FMI/gebuilder"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="autoupdate btrfs docker openstack test"

RESTRICT="network-sandbox"

COMMON_DEPEND="
	>=app-shells/bash-4.2:*
	net-misc/rsync
	sys-apps/portage
	sys-apps/util-linux
	sys-boot/syslinux
	sys-fs/duperemove
	sys-kernel/dracut
"
DEPEND="${COMMON_DEPEND}
	sys-devel/m4
"
RDEPEND="${COMMON_DEPEND}
	sys-process/lsof
	autoupdate? ( virtual/cron )
	btrfs? ( sys-fs/btrfs-progs )
	docker? ( >=app-emulation/docker-18.05.0 )
	openstack? ( dev-python/python-glanceclient )
"

src_prepare(){
	if use !docker; then
		rm -rf gebuilder/scripts/*docker* || die
		rm gebuilder/tests/*docker* || die
	fi
	if use !openstack; then
		rm -rf gebuilder/scripts/*openstack* || die
		rm gebuilder/tests/*openstack* || die
	fi
	default
}

src_unpack() {
	mkdir "$S" || die "Could not create the source directory"
	cp -r -L "$DOTGENTOO_PACKAGE_ROOT/"* -t "$S" || die "Could not copy $DOTGENTOO_PACKAGE_ROOT to $S"
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

src_test() {
	TMPDIR="${WORKDIR}/test_results"
	mkdir ${TMPDIR}
	cd gebuilder
	./tests.sh || die
}
