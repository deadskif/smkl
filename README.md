# smkl

Simple make lib


# Usage

## In your Makefile

> `MODULES = ` Modules list  
> `MODULE_MK = ` Module makefile name. Default `Makefile.in`  
>  
> `TOPDIR := $(CURDIR)`  
> `MKRULES := ` Path to rules.mk  
> `DESTDIR := `  
>  
> `INCLUDE_DIRS += ` Include dirs  
> `LINK_DIRS += ` Library search directories  
>  
> `CFLAGS += ` Global C compiler flags  
> `CXXFLAGS += ` Global C++ compiler flags  
> `LDFLAGS += ` Global linker flags  
>  
> `include $(MKRULES)/rules.mk`  

## In each $(MODULE)/$(MODULE_MK)

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
