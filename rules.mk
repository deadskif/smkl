.PHONY: all clean
RANLIB ?= ranlib

MODULE_MK ?= Makefile.in
_LAST_MODULE = $(dir $(lastword $(filter %/$(MODULE_MK),$(MAKEFILE_LIST))))
_GET_MODULE = $(strip $(foreach mod,$(MODULES),$(if $(filter $(mod)%,$1),$(mod))))

MODULE = $(if $(@D),$(call _GET_MODULE,$(@D)),$(_LAST_MODULE))

ifeq ($(MODULES),)
$(error Empty modules list)
endif

INSTALL ?= install -D
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 0644

OBJS :=
LIBS =
BINS =

CFLAGS += $(addprefix -I,$(INCLUDE_DIRS) $(INCLUDE_C_DIRS))
CXXFLAGS += $(addprefix -I,$(INCLUDE_DIRS) $(INCLUDE_CXX_DIRS))
LDFLAGS += $(addprefix -L,$(LINK_DIRS))

DEPSFLAGS = -MT $@ -MT $(@:.o=.d) -MF $(@:.o=.d) -MD -MP
CFLAGS += $(DEPSFLAGS)
CXXFLAGS += $(DEPSFLAGS)

# ###
# Rules
# ###
%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o,$^)
	$(RANLIB) $@

#%.so:
#	$(LINK.o) -shared $(filter %.o,$^) $(LDLIBS) -o $@

#%:
#	$(LINK.o) $(filter %.o,$^) $(LDLIBS) -o $@

# ###
# Defines
# ###
define make-objs
$1_OBJS = $(addprefix $(MODULE),$(filter-out /%,$2)) $(filter /%,$2)

OBJS += $$($1_OBJS)

$$($1): $$($1_OBJS)
endef

define make-link
$$($1):
	$$(LINK.o) -L${MODULE} $3 $$(filter %.o,$$^) $$(LDLIBS) $(addprefix -l,$2) -o $$@
endef

define make-install
.PHONY: $1 install-$1

$1: $$($1)

install-$1: $$($1)
	$$($2) $$($1) $$($3)/$$(notdir $$($1))
install: install-$1
endef

# Make binary
define make-binary
$1 = $(MODULE)$1
BINS += $$($1)

all: $$($1)
$(call make-objs,$1,$2,$3)
$(call make-link,$1,$3)
$(call make-install,$1,INSTALL_PROGRAM,bindir)
endef

# Make static library
define make-static-library
$1 = $(MODULE)lib$1.a
LIBS += $$($1)

$(call make-objs,$1,$2,$3)
$(call make-install,$1,INSTALL_DATA,libdir)

endef

# Make shared library
define make-shared-library
$1 = $(MODULE)lib$1.so
LIBS += $$($1)

all: $$($1)
$(call make-objs,$1,$2,$3)
$(call make-link,$1,$3,-shared)
$(call make-install,$1,INSTALL_PROGRAM,libdir)

$$($1_OBJS): CFLAGS += -fpic
$$($1_OBJS): CXXFLAGS += -fpic
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

include $(addsuffix /$(MODULE_MK),$(MODULES))

clean:
	rm -rf $(OBJS) $(OBJS:.o=.d)
	rm -rf $(BINS) $(LIBS)

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJS:.o=.d)
endif
