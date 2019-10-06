#!/bin/bash

## Set up a few environment variables and directories
##
## Namely, set up the docker buildid to be the current time in
## Unix timestamps, and the current tag to be the .gentoo-id with
## the last character repeated, and tagged by the buildid set before.
## Lastly, the registry director is created

DOCKER_BUILDID="$(date +%s)"
DOCKER_TAG="${MACHINE}${MACHINE: -1}:${DOCKER_BUILDID}"
ensure_dir "${ROOT}/../registry/"
