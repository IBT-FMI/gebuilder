#!/bin/bash

# Use this if the image is expected to exceed the default 10GB
# https://github.com/IBT-FMI/gebuilder/issues/15

/etc/init.d/docker stop
dockerd --storage-opt dm.basesize=20G &
sleep 3
kill -9 $(lsof -t -c docker)
/etc/init.d/docker start
sleep 3
