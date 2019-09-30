include config.mk

BUILDMODULES=
INITIMGOBJECTS=

include arch/Makefile
include kernel/Makefile
include drivers/Makefile

# Add modules
ifeq ($(BUILD_KERNEL), TRUE)
BUILDMODULES += arch kernel
endif
ifeq ($(BUILD_LIBC), TRUE)
BUILDMODULES += libc
endif
ifeq ($(BUILD_DRIVERS), TRUE)
BUILDMODULES += drivers
endif
ifeq ($(CREATE_ROOTDIR), TRUE)
BUILDMODULES += createRoot
endif
ifeq ($(LINK_INITIMG), TRUE)
BUILDMODULES += initimg
endif

.PHONY: all
all: $(BUILDMODULES)