TOPDIR := $(CURDIR)
MKRULES := $(abspath $(TOPDIR)/../..)
DESTDIR := $(TOPDIR)/../install_dir/


CFLAGS += -O2
CFLAGS += -Wall -Werror
CXXFLAGS += -O2 -Wall -Wextra
#LDFLAGS += -Wl,-rpath=$(TOPDIR)/lib
LDFLAGS += -Wl,-rpath=$(DESTDIR)/usr/local/lib

include $(MKRULES)/rules.mk
$(eval $(call make-binary,single,single.o))
$(single): CFLAGS += -DSINGLE_OK=1 -DMODULE="$(MODULE)"
