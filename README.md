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
