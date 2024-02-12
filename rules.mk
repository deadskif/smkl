.PHONY: all clean

MODULE_MK ?= Makefile.in

RANLIB ?= ranlib

ifneq ($(CROSS_COMPILE),)
CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
endif

INSTALL ?= install -D
INSTALL_PROGRAM ?= $(INSTALL)
INSTALL_DATA ?= $(INSTALL) -m 0644

OBJS :=
LIBS =
BINS =

ifneq ($(SYSROOT),)
TARGET_ARCH += --sysroot=$(SYSROOT)
endif

CFLAGS += $(addprefix -I,$(INCLUDE_DIRS) $(INCLUDE_C_DIRS))
CXXFLAGS += $(addprefix -I,$(INCLUDE_DIRS) $(INCLUDE_CXX_DIRS))
LDFLAGS += $(addprefix -L,$(LINK_DIRS))

CPPFLAGS += -MT $@ -MT $(@:.o=.d) -MF $(@:.o=.d) -MD -MP

SHAREDFLAGS ?= -fPIC
# ###
# Rules
# ###
%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o,$^)
	$(RANLIB) $@


# ###
# Defines
# ###

# make-objs
# $(1): name
# $(2): objects list
define make-objs
$1_OBJS = $(addprefix $(MODULE),$(filter-out /%,$2)) $(filter /%,$2)

OBJS += $$($1_OBJS)

$$($1): $$($1_OBJS)
$$($1): MODULE := $(if $(MODULE),$(MODULE),./)
endef

# make-link
# $(1): name
# $(2): libraries list
define make-link
$$($1):
	$$(LINK.o) $$(filter %.o,$$^) $$(LDLIBS) $(addprefix -l,$2) -o $$@
$$($1): private LINK_DIRS += $(if $(MODULE),$(MODULE))
endef

# make-install
# $(1): name
# $(2): install variable name
# $(3): dir variable to install
define make-install
ifneq ($1,$$($1))
.PHONY: $1
$1: $$($1)
endif

.PHONY: install-$1

install-$1: $$($1)
	$$($2) $$($1) $$($3)/$$(notdir $$($1))
install: install-$1
endef

# make-binary
# $(1): name
# $(2): objects list
# $(3): libraries list
define make-binary
$1 = $(MODULE)$1
BINS += $$($1)

all: $$($1)
$(call make-objs,$1,$2)
$(call make-link,$1,$3)
$(call make-install,$1,INSTALL_PROGRAM,bindir)
endef

# make-static-library
# $(1): name
# $(2): objects list
define make-static-library
$1 = $(MODULE)lib$1.a
LIBS += $$($1)

$(call make-objs,$1,$2)
$(call make-install,$1,INSTALL_DATA,libdir)
endef

# make-shared-library
# $(1): name
# $(2): objects list
# $(3): libraries list
define make-shared-library
$1 = $(MODULE)lib$1.so
LIBS += $$($1)

all: $$($1)
$(call make-objs,$1,$2)
$(call make-link,$1,$3)
$(call make-install,$1,INSTALL_PROGRAM,libdir)

$$($1_OBJS): CFLAGS += $(SHAREDFLAGS)
$$($1_OBJS): CXXFLAGS += $(SHAREDFLAGS)
$$($1): private LDFLAGS += -shared
endef


# ###
# Default dirs/prefixes
# ###
prefix ?= /usr/local
exec_prefix = $(prefix)
bindir = $(DESTDIR)$(exec_prefix)/bin
sbindir = $(DESTDIR)$(exec_prefix)/sbin
libdir = $(DESTDIR)$(exec_prefix)/lib

# ###
# Goals
# ###
all:


define INCLUDE_FILE
include $(MODULE)$(MODULE_MK)
endef
$(foreach MODULE,$(addsuffix /,$(MODULES)),$(eval $(INCLUDE_FILE)))

clean:
	rm -rf $(OBJS) $(OBJS:.o=.d)
	rm -rf $(BINS) $(LIBS)

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJS:.o=.d)
endif
