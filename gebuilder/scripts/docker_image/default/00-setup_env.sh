#!/bin/bash

DOCKER_BUILDID="$(date +%s)"
DOCKER_TAG="${MACHINE}${MACHINE: -1}:${DOCKER_BUILDID}"
ensure_dir "${ROOT}/../registry/"
