#!/bin/bash

set -e

ROOT_DIR="$(dirname "$(realpath "$0")")/../"
ROOT_DIR="${1:-$ROOT_DIR}"

pushd "${ROOT_DIR}"
buildserver stemgentoo update
for file in roots/*/.gentoo/
do
	buildserver "$file" update
done
popd
