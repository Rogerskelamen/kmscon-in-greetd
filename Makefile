GREETD_USER  = greeter
SUDOERS_MODE = 440
DESTDIR      =
PREFIX       = /usr/local
SYSCONFDIR   = /etc

all: accessvt grantvt grantvt.sudoers kmscon-fg

install: all
	install -d $(DESTDIR)$(SYSCONFDIR)/sudoers.d
	install -m$(SUDOERS_MODE) grantvt.sudoers \
		$(DESTDIR)$(SYSCONFDIR)/sudoers.d/grantvt

	install -d $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/sbin
	install -m755 accessvt kmscon-fg $(DESTDIR)$(PREFIX)/bin/
	install -m755 grantvt $(DESTDIR)$(PREFIX)/sbin/

uninstall:
	rm -f $(DESTDIR)$(SYSCONFDIR)/sudoers.d/grantvt
	rm -f $(DESTDIR)$(PREFIX)/bin/accessvt $(DESTDIR)$(PREFIX)/bin/kmscon-fg
	rm -f $(DESTDIR)$(PREFIX)/sbin/grantvt

clean:
	rm -f grantvt.sudoers

grantvt.sudoers: grantvt.sudoers.in
	sed -e "s|@PREFIX@|$(PREFIX)|" -e "s|@GREETD_USER@|$(GREETD_USER)|" $? > $@
