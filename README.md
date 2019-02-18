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

Systems which are intended to serve as builders (creating images via the capacities of gebuilder), will invariably accummulate large amounts of duplicated content.
To efficiently handle this, using a [Btrfs](https://en.wikipedia.org/wiki/Btrfs) filesystem is recommended.
Gebuilder makes this particularly accessible, by optionally building Btrfs-formatted images out of the box.
To select Btrfs as the format for e.g. an OpenStack image, run:

```
cp /usr/share/gebuilder/config/openstack.conf /usr/share/gebuilder/roots/<ID>/config/openstack.conf
```

Edit `/usr/share/gebuilder/roots/<ID>/config/openstack.conf` to contain:

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

Once the image is booted, note that it may be necessary to grow the Btrfs filesystem to fit the partition (the sizes may vary from provider to provider):

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
builder ~ # emerge btrfs-progs
builder ~ # btrfs filesystem resize +92G /
```

## Known Issues

The following list contains solutions to issues commonly encountered with gebuilder, as well as with the services it depends on.
Particularly Docker seems to cause a number of issues.
For convenience we keep a list of issues and their solutions here, though this section may more appropriately moved elsewhere in the future.

### Debugging a Failed Initialization

Occasionally the initialization for a new `.gentoo` directory may fail (most commonly due to issues with the required ebuilds).
By default, all traces of this attempted system (except the logs) are deleted - and this is by design, in order to prevent accumulation of cruft.
If you wish to preserve the system, in order to chroot into it manually and try to diagnose or fix the issue in place, make sure the following line in `/usr/share/gebuilder/config/generic.conf` is commented:

```shell
#DELETE_ON_FAIL=1
```

### Docker images not being built

Depending on your system set-up, even after installing docker, the daemon may not yet be started.
The daemon will have to be enabled depending on your service manager.

#### On OpenRC run:

```
/etc/init.d/docker enable
rc-update add /etc/init.d/docker default
```

#### On systemd run:

```
systemctl docker start
systemctl docker enable
```

chpasswd: Cannot determine your user name.

### Issues connecting to Docker

A number of legacy login styles explicitly specifying the service may fail, e.g.:

```
docker login hub.docker.com
```

Currently, Dockerhub login is best performed with the Dockerhub address handled implicitly:

```
docker login
```
