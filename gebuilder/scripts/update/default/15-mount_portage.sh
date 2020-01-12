#!/bin/bash

## Bind mount the stemgentoo main portage directory to the childs root
##
## This allows us to not sync the portage tree multiple times, which is
## considered bad behaviour

DIRA="$(get_distdir "${ROOT}")"
DIRB="$(get_distdir "roots/stemgentoo/root/")"

ensure_dir "${DIRA}"
mount -o bind "${DIRB}" "${DIRA}"
on_exit "umount '${DIRA}'"

DIRA="$(get_portdir "${ROOT}")"
DIRB="$(get_portdir "roots/stemgentoo/root/")"

ensure_dir "${DIRA}"
mount -o bind "${DIRB}" "${DIRA}"
on_exit "umount '${DIRA}'"
