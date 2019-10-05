INSTALL=install
PREFIX=/usr

%: %.m4 Makefile
	m4 -DINSTALL=$(INSTALL) -DPREFIX=$(PREFIX) $< > $@

install: gebuilder/gebuild
	find gebuilder/{utils,config} -type f -exec install -D -m 0644 {} $(DESTDIR)$(PREFIX)/share/{} \;
	find gebuilder/{example_hooks,exec.sh,scripts} -type f -exec install -D -m 0755 {} $(DESTDIR)$(PREFIX)/share/{} \;
	$(INSTALL) -D -m 0755 -t $(DESTDIR)$(PREFIX)/bin/ gebuilder/gebuild
