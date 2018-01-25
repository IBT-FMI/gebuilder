#!/bin/bash

TAG="buffepva/repositorg:${DOCKER_BUILDID}"
LATEST_TAG="buffepva/repositorg:latest"

for tag in "$TAG" "$LATEST_TAG"
do
	docker tag "${DOCKER_TAG}" "${tag}"
	docker push "${tag}"
done
