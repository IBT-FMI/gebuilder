#!/bin/bash

EBUILD="$(get_ebuild "${ROOT}/../.gentoo")"
STAGE4_IMAGE_NAME=${EBUILD%-99999.ebuild}
STAGE4_IMAGE_NAME=${STAGE4_IMAGE_NAME##*/}

STAGE4_IMAGE_DIR="${ROOT}/../stage4_images/"
ensure_dir "${STAGE4_IMAGE_DIR}"
STAGE4_IMAGE="${STAGE4_IMAGE_DIR}/${STAGE4_IMAGE_NAME}"

debug "Creating tarball..."
pushd "${ROOT}"
	tar cJf "${STAGE4_IMAGE}.tar.xz" .
popd
