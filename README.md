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

## Known Issues

### Debugging a Failed Initialization

Occasionally the initialization for a new `.gentoo` directory may fail (most commonly due to issues with the required ebuilds).
By default, all traces of this attempted system (except the logs) are deleted - and this is by design, in order to prevent accumulation of cruft.
If you wish to preserve the system, in order to chroot into it manually and try to diagnose or fix the issue in place, make sure the following line in `/usr/share/gebuilder/config/generic.confiig` is commented:

```shell
#DELETE_ON_FAIL=1
```
