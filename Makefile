PROG ?= otptool
DESTDIR ?= /usr/local

all:
	$(MAKE) build

help:
	@echo "ValaOtp is a vala app that parse the url parameter and call oathtool for generate an otp"
	@echo
	@echo "To build it use \"make build\""
	@echo
	@echo "To install it globally use \"make install\""
	@echo "To install it locally use \"make local\""
	@echo
	@echo "To uninstall it globally use \"make uninstall\""
	@echo "To uninstall it locally use \"make remove\""
	@echo

install:
	@echo
	@echo "Install $(PROG) in $(DESTDIR)/bin"
	@echo
	install -m 0755 "$(PROG)" "$(DESTDIR)/bin/$(PROG)"
	@echo
	@echo "$(PROG) is installed succesfully in $(DESTDIR)/bin"
	@echo

uninstall:
	rm -f "$(DESTDIR)/bin/$(PROG)"
	@echo
	@echo "$(PROG) is removed succesfully from $(DESTDIR)/bin"
	@echo

build:
	valac --output=$(PROG) valaotp.vala

local:
	DESTDIR=${HOME}/.local $(MAKE) install

remove:
	DESTDIR=${HOME}/.local $(MAKE) uninstall


