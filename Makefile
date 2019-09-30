include config.mk

MODULES=
INITIMGOBJECTS=

include arch/Makefile
include kernel/Makefile
include drivers/Makefile

# Add modules
ifeq ($(BUILD_KERNEL), TRUE)
MODULES += arch kernel
endif
ifeq ($(BUILD_LIBC), TRUE)
MODULES += libc
endif
ifeq ($(BUILD_DRIVERS), TRUE)
MODULES += drivers
endif
ifeq ($(CREATE_ROOTDIR), TRUE)
MODULES += createRoot
endif
ifeq ($(LINK_INITIMG), TRUE)
MODULES += initimg
endif

.PHONY: all
.PHONY: clean
all: $(MODULES)

clean:
	@find . -name "*.o" -type f -delete