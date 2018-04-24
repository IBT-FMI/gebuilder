pushd ${ROOT}/../openstack_images/
	ls -tp | grep -v '/$' | tail -n +3 | xargs -I {} rm -- {}
popd
