#!/bin/bash

DOCKER_IMGNAME="${DOCKER_TAG}"
pushd "${ROOT}/../"
docker build -t "${DOCKER_IMGNAME}" "."

echo "$DOCKER_IMGNAME" >> "${ROOT}"/../registry/docker_images
echo "$DOCKER_IMGNAME" > "${ROOT}"/../registry/latest_docker_image
popd
export DOCKER_IMGNAME
