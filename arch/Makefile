ARCHDIR=arch
ARCHDIR_FULL=$(SOURCE_DIR)/arch
ARCHOBJECTS=

include arch/$(ARCH)/Makefile

INITIMGOBJECTS += $(SOURCE_DIR)/arch/arch.o

.PHONY: arch
arch: $(ARCH)