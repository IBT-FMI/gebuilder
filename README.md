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

During the initialization of any `.gentoo` directory, portage requires permission to the full path of a processed copy of the original ebuild.
If the `gebuild` commands are run directly in the root home directory, portage will be lacking the required access rights (this happens even if the original `.gentoo` directory is in a portage readable path).
Thus:

```
cd /home/youruser
git clone https://github.com/IBT-FMI/StereotaXYZ.git
su -
gebuilder /home/youruser/StereotaXYZ
```

Will fails with a Permission Error.

This issue can be fixed by running:

```
chmod +x /root/
```

This is a potential security liability, and should only be performed if you have no sensitive data under `/root/`.
