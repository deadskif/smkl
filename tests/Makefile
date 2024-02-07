MODULES = bin lib submodules/subbin


TOPDIR := $(CURDIR)
MKRULES := $(abspath $(TOPDIR)/..)
DESTDIR := $(TOPDIR)/install_dir/

INCLUDE_DIRS += $(TOPDIR)/include
LINK_DIRS += lib

CFLAGS += -O2
CFLAGS += -Wall -Werror
#LDFLAGS += -Wl,-rpath=$(TOPDIR)/lib
LDFLAGS += -Wl,-rpath=$(DESTDIR)/usr/local/lib

include $(MKRULES)/rules.mk

# Dependencies
$(test_bin): $(test_lib)
