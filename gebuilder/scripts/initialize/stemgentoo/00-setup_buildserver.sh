#!/bin/bash

## Global buildserver setup
##
## Ensures that the cache-dir and the roots directory exist

ensure_dir roots
ensure_dir "$CACHE"
