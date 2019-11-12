ARCHDIR=arch
ARCHDIR_FULL=$(SOURCE_DIR)/arch
ARCHOBJECTS=

ifeq ($(ARCH), X86)
include arch/X86/Makefile
DEFINE_VALS += -D_X86_
else
include arch/X86_64/Makefile
DEFINE_VALS += -D_X86_64_
endif

INITIMGOBJECTS += $(SOURCE_DIR)/arch/arch.o

.PHONY: arch

ifeq ($(ARCH), X86_64)
arch: arch_x86_64
endif
ifeq ($(ARCH), X86)
arch: arch_x86
endif