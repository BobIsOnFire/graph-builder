SUBDIRS := $(dir $(wildcard */Makefile))

all install clean: $(SUBDIRS)

$(SUBDIRS):
	@$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: all install clean $(SUBDIRS)
