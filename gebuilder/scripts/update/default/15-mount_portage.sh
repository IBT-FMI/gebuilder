#!/bin/bash

DIRA="$(get_portdir "${ROOT}")"
DIRB="$(get_portdir "roots/stemgentoo/root/")"

ensure_dir "{DIRA}"
mount -o bind "${DIRB}" "${DIRA}"
on_exit "umount '${DIRA}'"
