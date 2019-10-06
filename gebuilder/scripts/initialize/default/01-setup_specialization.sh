#!/bin/bash

## Sets up the specialization, i.e. everything connected with the .gentoo-direcory
##
## This sets up an overlay containing solely the ebuild contained in the .gentoo overlay
## and copies over the package.{accept_keywords,mask,unmask,use}-files

debug "Setting up the target ebuild overlay"
OVERLAYDIR="${ROOT}/var/buildsrv/overlay"
ensure_dir "${OVERLAYDIR}"
EBUILD="$(get_ebuild "${ROOT}/../.gentoo")"
if [ -z "${EBUILD}" ]
then
	error "No ebuild found in .gentoo"
	error_exit
fi

debug "Using ebuild $EBUILD"
debug "Setting up buildserver-overlay in ${OVERLAYDIR}"
ensure_dir "${OVERLAYDIR}"
ensure_dir "${OVERLAYDIR}/profiles"
ensure_dir "${OVERLAYDIR}/metadata"
ensure_dir "${OVERLAYDIR}/buildserver-specialization"
ensure_dir "${OVERLAYDIR}/buildserver-specialization/specialization/"
cat >>${OVERLAYDIR}/metadata/layout.conf <<-EOF
masters = gentoo
EOF
echo buildserver-specialization >> "${OVERLAYDIR}/profiles/categories"
echo buildserver-specialization >> "${OVERLAYDIR}/profiles/repo_name"
cp "${EBUILD}" "${OVERLAYDIR}/buildserver-specialization/specialization/specialization-9999.ebuild"
PORTAGE_USERNAME=root PORTAGE_GRPNAME=root ebuild "${OVERLAYDIR}/buildserver-specialization/specialization/specialization-9999.ebuild" manifest

debug "Setting up the additional repos"
ensure_dir "${ROOT}/etc/portage/repos.conf"
for file in "${ROOT}/../.gentoo/overlays/"*
do
        echo "Attempting to copy ${file}."
        if [ -f "$file" ];
                then cp "$file" "${ROOT}/etc/portage/repos.conf/" &&
                echo "Coiped!";
        fi
done

cat > ${ROOT}/etc/portage/repos.conf/buildserver-specialization.conf <<-EOF
[buildserver-specialization]
masters = gentoo
location = /var/buildsrv/overlay
EOF

for dir in package.{accept_keywords,mask,unmask,use}
do
	file="${ROOT}/../.gentoo/${dir}"
        if [ -f "$file" ]
	then
		ensure_dir "${ROOT}/etc/portage/$dir/"
		cp "$file" "${ROOT}/etc/portage/$dir/"
	elif [ -d "$file" ]
	then
		ensure_dir "${ROOT}/etc/portage/$dir/"
		cp -t "${ROOT}/etc/portage/$dir/" "$file"/* 
	fi
done

