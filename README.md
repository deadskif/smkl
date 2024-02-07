# smkl

Simple make lib


# Usage

## In your Makefile

> `MODULES = ` modules list
> `MODULE_MK = ` module makefile name. default `Makefile.in`
>
> `TOPDIR := $(CURDIR)`
> `MKRULES := ` path to rules.mk
> `DESTDIR := ` 
> 
> `INCLUDE_DIRS += ` include dirs
> `LINK_DIRS += ` library
> 
> `CFLAGS += `
> `CXXFLAGS += `
> `LDFLAGS += `
> 
> `include $(MKRULES)/rules.mk`

## In each $(MODULE)/$(MODULE_MK)
> 
> `$(eval $(call make-binary,` *binary-name* `,` *binary-objects-list* `,` *binary-libraries-list* `))`
> `$(` *binary-name* `_OBJS): CFLAGS += ` C compiler flags for *binary-name* objects
> `$(` *binary-name* `: INCLUDE_DIRS += ` Include directories for *binary-name*
> `$(` *binary-name* `: LDFLAGS += ` Linker flags for *binary-name*
> 
> `$(eval $(call make-static-library,` *static-library-name* `,` static-library-objects-list `))`
> `$(` *static-library-name* `_OBJS): CFLAGS += ` C compiler flags for *static-library-name* objects
> `$(eval $(call make-shared-library,` *shared-library-name* `,` shared-library-objects-list `,` shared-library-libraries-list `))`
> `$(` *shared-library-name* `_OBJS): CFLAGS += ` C compiler flags for *shared-library-name* objects
> `# Dependencies`
> `$(` *binary-name* `): $(` *shared-library-name* `)`
