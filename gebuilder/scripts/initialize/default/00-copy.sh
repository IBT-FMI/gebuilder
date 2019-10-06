#!/bin/bash

## Copies the stemgentoo to this images' root
##
## @DELETE_ON_FAIL: When variable set, delete the image if initialization fails

if [ ! -d  "roots/stemgentoo/root/" ]; then
       error "Stemgentoo was not initialized"
       error exit
fi

if [[ -v DELETE_ON_FAIL ]]; then on_error "rm --one-file-system -r '${ROOT}'"; fi

rsync -a roots/stemgentoo/root/ "${ROOT}"
