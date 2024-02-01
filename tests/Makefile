MODULES = bin lib


TOPDIR := $(CURDIR)
MKRULES := $(abspath $(TOPDIR)/..)

INCLUDE_DIRS += $(TOPDIR)/include
LINK_DIRS += lib

CFLAGS += -O2
CFLAGS += -Wall -Werror
LDFLAGS += -Wl,-rpath=$(TOPDIR)/lib

include $(MKRULES)/rules.mk

# Dependencies
$(test_bin): $(test_lib)

