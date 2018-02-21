# GeBuilder

GeBuilder is a Gentoo system and image builder which can produce system tarballs, OpenStack Images, and Docker containers based on the `.gentoo` live package distribution standard.

## Installation

The package can be installed via the `.gentoo` standard.
To perform this, run:

```
cd /home/youruser
git clone https://github.com/IBT-FMI/gebuilder.git
su -
cd /home/youruser/gebuilder/.gentoo
./install.sh
```

## Features

### Btrfs Support

Systems which are intended to serve as builders (creating images via the capacities of gebuilder), will invariably contain large amounts of duplicated content.
To efficiently handle this, running the said systems on [btrfs](https://en.wikipedia.org/wiki/Btrfs) partitions is recommended.
Gebuilder makes this particularly accessible, by optionally building btrfs-formatted images.
To select btrfs as the format for e.g. an openstack image, run:

```
cp /usr/share/gebuilder/config/openstack.conf /usr/share/gebuilder/roots/<ID>/config/openstack.conf
```

Edit the file to contain:

```
OS_IMGNAME="stemgentoo_btrfs"
OPENSTACK_IMAGE_NAME="image_$(date "+%Y%m%d")"
OPENSTACK_ROOT_PASSWORD="t00r"
OPENSTACK_FILESYSTEM="btrfs"

#Syslinux can't handle 64bit, so we disable it.
#This has the effect, that our root partition can't grow larger than 2TB
OPENSTACK_FILESYSTEM_OPTS=""
```

And create it - as usually - with:

```
gebuild <stemgentoo OR path to .gentoo> openstack_image
```

Once the image is booted, please note that it may be necessary to grow the btrfs filesystem to fit the partition(the sizes may vary from provider to provider):

```
builder ~ # df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs         10M     0   10M   0% /dev
tmpfs            16G     0   16G   0% /dev/shm
tmpfs            16G  328K   16G   1% /run
/dev/vda1       7.0G  2.9G  4.1G  41% /
cgroup_root      10M     0   10M   0% /sys/fs/cgroup
builder ~ # fdisk -l
Disk /dev/vda: 100 GiB, 107374182400 bytes, 209715200 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x2861f5b3

Device     Boot Start       End   Sectors  Size Id Type
/dev/vda1  *     2048 209715166 209713119  100G 83 Linux
```

If there is a difference between the disk and the volume, add it to the btrfs filesystem:

```
builder ~ # emerge btrfs-pogs
builder ~ # btrfs filesystem resize +92G /
```

## Known Issues

### Permission Error for Specialization Ebuilds

During the initialization of any `.gentoo` directory, Portage requires access to the full path of a processed copy of the original ebuild (the so-called “specialization ebuild”).
If the `gebuild` commands are run directly in the root home directory, Portage will be lacking the required access rights (this happens even if the original `.gentoo` directory is in a Portage readable path).
Thus:

```
cd /home/youruser
git clone https://github.com/IBT-FMI/StereotaXYZ.git
su -
gebuilder /home/youruser/StereotaXYZ
```

Will fail with a Permission Error.

This issue can be fixed by running:

```
chmod +x /root/
```

This is a potential security liability, and should only be performed if you have no sensitive data under `/root/`.

### Debugging a Failed Initialization

Occasionally the initialization for a new `.gentoo` directory may fail (most commonly due to issues with the required ebuilds).
By default, all traces of this attempted system (except the logs) are deleted - and this is by design, in order to prevent accumulation of cruft.
If you wish to preserve the system, in order to chroot into it manually and try to diagnose or fix the issue in place, make sure the following line in `/usr/share/gebuilder/config/generic.confiig` is commented:

```shell
#DELETE_ON_FAIL=1
```
