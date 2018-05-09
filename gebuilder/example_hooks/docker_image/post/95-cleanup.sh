#!/bin/bash

# Docker is conspicuously difficult to clean up:
# https://github.com/IBT-FMI/gebuilder/issues/17

docker rmi -f $(docker images -q)
/etc/init.d/docker restart
sleep 5
/etc/init.d/docker stop
rm -rf /var/lib/docker/devicemapper
/etc/init.d/docker start
