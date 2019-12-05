#!/bin/bash

OS_USER=""
OS_PW=""
OS_TENANT=""
OS_IMG_BASENAME=""

function gl(){
glance --os-username "$OS_USER" \
  --os-password "$OS_PW" \
  --os-tenant-name "$OS_TENANT" \
  --os-auth-url https://cloud.s3it.uzh.ch:5000/v2.0 \
  --os-image-api-version 2 "$@"
}

if [ -f "${ROOT}/../registry/openstack_image" ]
then
        UUID="$(sed -n  's/|[[:blank:]]\+id[[:blank:]]\+|[[:blank:]]\+\([a-z0-9\-]\+\)[[:blank:]]\+|/\1/p' "${ROOT}/../registry/openstack_image")"
        debug "Deleting old image with uuid $UUID"
        gl image-delete "$UUID" || true
else
        ensure_dir "${ROOT}/../registry/"
fi
# Calling `cleanup` here patches https://github.com/IBT-FMI/gebuilder/issues/11
cleanup
regfile="${ROOT}/../registry/openstack_image"

if [ -z "${OPENSTACK_IMG}" ]
then
        IMGS_DIR="${ROOT}/../openstack_images"
        LATEST_IMG_BASENAME=$(ls -t ${IMGS_DIR} | head -1)
        OPENSTACK_IMG="${IMGS_DIR}/${LATEST_IMG_BASENAME}"
fi

LATEST_IMG=$(basename "${OPENSTACK_IMG}")
OS_IMGNAME="${OS_IMG_BASENAME}-${LATEST_IMG}"
debug "Uploading new image with name $OS_IMGNAME"
gl image-create --disk-format raw --container-format bare --name "$OS_IMGNAME" --file "$OPENSTACK_IMG" \
        >"${regfile}.tmp"\
        && mv "${regfile}.tmp" "${regfile}"\
        || (rm "${regfile}.tmp"; false)

