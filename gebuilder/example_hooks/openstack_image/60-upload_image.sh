#!/bin/bash

OS_USER=""
OS_PW=""
OS_TENANT=""
OS_IMGNAME=""

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
	gl image-delete "$UUID"
else
	ensure_dir "${ROOT}/../registry/"
fi
cleanup
debug "Uploading new image with name $OS_IMGNAME"
gl image-create --disk-format raw --container-format bare --name "$OS_IMGNAME" --file "$OPENSTACK_IMAGE" >"${ROOT}/../registry/openstack_image"

