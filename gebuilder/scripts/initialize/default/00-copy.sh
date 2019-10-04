#!/bin/bash

if [ ! -f  "/var/lib/gebuilder/roots/stemgentoo/root/" ]; then 
       error "Stemgen was not initialized"
       error exit
fi

if [[ -v DELETE_ON_FAIL ]]; then on_error "rm --one-file-system -r '${ROOT}'"; fi

rsync -a /var/lib/gebuilder/roots/stemgentoo/root/ "${ROOT}"
