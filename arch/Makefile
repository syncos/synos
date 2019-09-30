ARCHDIR=$(SOURCE_DIR)/arch
ARCHOBJECTS=

ifeq ($(ARCH), X86)
include arch/X86/Makefile
else
include arch/X86_64/Makefile
endif

INITIMGOBJECTS += $(SOURCE_DIR)/arch/arch.o

.PHONY: arch

ifeq ($(ARCH), X86_64)
arch: arch_x86_64
endif
ifeq ($(ARCH), X86)
arch: arch_x86
endif