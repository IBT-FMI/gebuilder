INSTALL ?= install
PREFIX ?= /usr
GEBUILDER_ROOT ?=$(PREFIX)/share/gebuilder
MANDIR ?= $(PREFIX)/share/man
BINDIR ?= $(PREFIX)/bin/
CACHEDIR ?= /var/cache/gebuilder
IMAGESDIR ?= /var/lib/gebuilder

BUILDFILES = gebuilder/gebuild

all: gebuilder/gebuild

doc/gebuild.8: doc/gebuild.8.m4 $(wildcard gebuilder/scripts/*/*.sh gebuilder/scripts/*/*/*.sh) ./gebuilder/utils/docgenerator.sh
	./gebuilder/utils/docgenerator.sh gebuilder/scripts | m4 $< > $@

gebuilder/gebuild: gebuilder/gebuild.m4 Makefile
	m4 -DCACHEDIR=$(CACHEDIR) -DIMAGESDIR=$(IMAGESDIR) -DPREFIX=$(PREFIX) -DGEBUILDER_ROOT=$(GEBUILDER_ROOT) $< > $@
	chmod a+x $@

.PHONY: install
install: gebuilder/gebuild doc/gebuild.8 doc/dotgentoo.5
	cd gebuilder; find utils config -type f -exec install -D -m 0644 {} $(DESTDIR)$(GEBUILDER_ROOT)/{} \;
	cd gebuilder; find example_hooks exec.sh scripts -type f -exec install -D -m 0755 {} $(DESTDIR)$(GEBUILDER_ROOT)/{} \;
	$(INSTALL) -D -m 0755 -t $(DESTDIR)$(BINDIR) gebuilder/gebuild
	$(INSTALL) -D -m 0644 -t $(DESTDIR)$(MANDIR)/man8/ doc/gebuild.8
	$(INSTALL) -D -m 0644 -t $(DESTDIR)$(MANDIR)/man5/ doc/dotgentoo.5
