# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Gentoo System and Image Builder"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="autoupdate"

DEPEND="
	sys-kernel/dracut
	>=app-shells/bash-4.2
	sys-apps/util-linux
	sys-fs/duperemove
	sys-apps/portage
	net-misc/rsync
"
RDEPEND="${DEPEND}
	autoupdate? ( virtual/cron )
"

src_unpack() {
	mkdir "$S"
	cp -r -L "$DOTGENTOO_PACKAGE_ROOT/"{exec.sh,config,doc,example_hooks,scripts,tests,utils,tests.sh} -t "$S"
}

src_install() {
	insinto /usr/share/gebuilder
	doins -r utils config
	cat >gebuild <<-EOF
#!/bin/sh

exec /usr/share/gebuilder/exec.sh "\$@"
EOF
	dobin gebuild
	insopts "-m0755"
	doins -r exec.sh scripts
}
