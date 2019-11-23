#!/bin/bash

STAGE4_IMAGE_DIR="${ROOT}/../stage4_images/"
ensure_dir "${STAGE4_IMAGE_DIR}"
STAGE4_IMAGE_NAME="$(date "+%Y-%m-%d")"
STAGE4_IMAGE="${STAGE4_IMAGE_DIR}/${STAGE4_IMAGE_NAME}"

debug "Creating tarball..."
pushd "${ROOT}"
	tar cJf "${STAGE4_IMAGE}.tar.xz" .
popd
