#!/bin/bash

# This may need to be done because Docker+devicemapper don't adequately clean up after themselves
# https://github.com/moby/moby/issues/3182
# Fix from here:
# https://lebkowski.name/docker-volumes/

echo 'Removing all docker images and traces.'

# remove exited containers:
docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v

# remove unused images:
docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi

# remove unused volumes:
find '/var/lib/docker/volumes/' -mindepth 1 -maxdepth 1 -type d | grep -vFf <(
  docker ps -aq | xargs docker inspect | jq -r '.[] | .Mounts | .[] | .Name | select(.)'
  ) | xargs -r rm -fr
