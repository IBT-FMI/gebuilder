#!/bin/bash

## Builds the dockerimage, registering its name in the images registry.
##
## Inside the registry in roots/<id>/registry/latest_docker_image lays
## the most recently generated docker image tag name, and inside
## roots/<id>/registry/docker_images lie all the docker image tags in
## chronological order

DOCKER_IMGNAME="${DOCKER_TAG}"
pushd "${ROOT}/../"
docker build -t "${DOCKER_IMGNAME}" "."

echo "$DOCKER_IMGNAME" >> "${ROOT}"/../registry/docker_images
echo "$DOCKER_IMGNAME" > "${ROOT}"/../registry/latest_docker_image
popd
export DOCKER_IMGNAME
