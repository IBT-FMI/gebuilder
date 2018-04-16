pushd ${ROOT}/../registry/
	ls -tp | grep -v '/$' | tail -n +3 | xargs -I {} rm -- {}
popd
