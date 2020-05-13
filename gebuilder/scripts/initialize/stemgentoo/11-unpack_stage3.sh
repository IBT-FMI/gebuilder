#!/bin/bash

## Unpack the latest stage3 tarball from the cache directory
echo "	Running \"tar xvJf ${CACHE}/stage3_latest.tar.xz -C ${ROOT}\" in background."
tar xvJf "${CACHE}"/stage3_latest.tar.xz -C "${ROOT}" &> /dev/null
