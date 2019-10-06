#!/bin/bash

## Deduplicates the images files on the underlying filesystem
##
## This requires the gebuilder to reside on a btrfs-Filesystem

duperemove --hashfile="${CACHE}/duperemove_hashfile" -d -r -x "${ROOT}" "${ROOT}/../../stemgentoo/root"
