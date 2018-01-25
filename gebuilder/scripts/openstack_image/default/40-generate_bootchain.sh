#!/bin/bash

KERNEL="$(readlink ${OPENSTACK_IMG_MNT}/usr/src/linux)"
KERNELVERSION="${KERNEL%-*}"
KERNELVERSION="${KERNELVERSION#*-}"

debug "Copying syslinux files"
mkdir ${OPENSTACK_IMG_MNT}/boot/syslinux
cp /usr/share/syslinux/{menu.c32,memdisk,libcom32.c32,libutil.c32} "${OPENSTACK_IMG_MNT}/boot/syslinux/"

debug "Installing extlinux"
extlinux --device="${OPENSTACK_IMG_LODEV}p1" --install "${OPENSTACK_IMG_MNT}/boot/syslinux/"

debug "Writing bootloader, booting from UUID $OPENSTACK_IMG_UUID"
cat <<-EOF > ${OPENSTACK_IMG_MNT}/boot/syslinux/syslinux.cfg
DEFAULT gentoo
LABEL gentoo
      LINUX /boot/vmlinuz root=UUID=$OPENSTACK_IMG_UUID rootfstype=ext4 console=ttyS0,115200n8
      INITRD /boot/initramfs
EOF

debug "Writing fstab root-entry"
cat <<-EOF >> ${OPENSTACK_IMG_MNT}/etc/fstab
UUID=$UUID              /               ext4            noatime         0 1
EOF

INITRAMFS="${OPENSTACK_IMG_MNT}/boot/initramfs-$KERNELVERSION"
debug "Generating initramfs $INITRAMFS"
dracut --no-kernel -m "base rootfs-block" "$INITRAMFS" "$KERNELVERSION"
ln -s "initramfs-$KERNELVERSION" "${OPENSTACK_IMG_MNT}/boot/initramfs"

