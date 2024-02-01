.PHONY: all clean
RANLIB ?= ranlib

MODULE = $(dir $(lastword $(MAKEFILE_LIST)))
MODULE_MK ?= Makefile.in
#CC = $(CROSS_COMPILE)gcc
ifeq ($(MODULES),)
$(error Empty modules list)
endif

OBJS :=
LIBS =
BINS =

CFLAGS += $(addprefix -I,$(INCLUDE_DIRS))
LDFLAGS += $(addprefix -L,$(LINK_DIRS))

# Rules
%.d : %.c
	$(COMPILE.c) -M -MT $@ -MF $@ -MMD $<

%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o,$^)
	$(RANLIB) $@

#%.so:
#	$(LINK.o) -shared $(filter %.o,$^) $(LDLIBS) -o $@

#%:
#	$(LINK.o) $(filter %.o,$^) $(LDLIBS) -o $@

define make-objs
$1_OBJS = $(addprefix $(MODULE),$2)

OBJS += $$($1_OBJS)

$$($1): $$($1_OBJS)
endef

define make-link
$$($1):
	$$(LINK.o) -L${MODULE} $3 $$(filter %.o,$$^) $$(LDLIBS) $(addprefix -l,$2) -o $$@
endef

define make-binary
$1 = $(MODULE)$1
$(call make-objs,$1,$2,$3)

all: $$($1)

BINS += $$($1)

$(call make-link,$1,$3)
endef

define make-static-library
$1 = $(MODULE)lib$1.a
$(call make-objs,$1,$2,$3)

LIBS += $$($1)
endef

define make-shared-library
$1 = $(MODULE)lib$1.so
$(call make-objs,$1,$2,$3)

all: $$($1)

LIBS += $$($1)
$$($1_OBJS): CFLAGS += -fpic

$(call make-link,$1,$3,-shared)
endef

all:

include $(addsuffix /$(MODULE_MK),$(MODULES))

clean:
	rm -rf $(OBJS) $(OBJS:.o=.d)
	rm -rf $(BINS) $(LIBS)

ifneq ($(MAKECMDGOALS),clean)
include $(OBJS:.o=.d)
endif
