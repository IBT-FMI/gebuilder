#!/bin/bash

if [[ -v DELETE_ON_FAIL ]]; then on_error "rm --one-file-system -r '${ROOT}'"; fi

rsync -a roots/stemgentoo/root/ "${ROOT}"
