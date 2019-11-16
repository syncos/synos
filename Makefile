include .global
include .config

MODULES=startM
INITIMGOBJECTS=

.PHONY: all
all: initimg

include arch/Makefile
include kernel/Makefile
include drivers/Makefile
include mutils/Makefile

# Add modules
MODULES += kernel arch mutils drivers

ifeq ($(BUILD_TYPE), DEBUG)
DEBUG=TRUE
OPTIMIZE=FALSE
DEFINE_VALS += -DBUILD_TYPE=\"DEBUG\"
endif
ifeq ($(BUILD_TYPE), RELEASE)
DEBUG=FALSE
OPTIMIZE=TRUE
DEFINE_VALS += -DBUILD_TYPE=\"RELEASE\"
endif
ifeq ($(ASSEMBLY), TRUE)
CC_FLAGS += -S
CXX_FLAGS += -S
DEFINE_VALS += -DASSEMBLY
endif
ifeq ($(DEBUG), TRUE)
CC_FLAGS += -gdwarf
CXX_FLAGS += -gdwarf
ASM_FLAGS += -g -F dwarf
LINK_FLAGS += -g
DEFINE_VALS += -DDEBUG
endif
ifeq ($(OPTIMIZE), TRUE)
CC_FLAGS += -O2
CXX_FLAGS += -O2
ASM_FLAGS += -O2
LINK_FLAGS += -O
DEFINE_VALS += -DOPTIMIZE
endif
ifeq ($(BITS), 64)
CC_FLAGS += -m64
CXX_FLAGS += -m64
DEFINE_VALS += -D_64BIT_
else
CC_FLAGS += -m32
CXX_FLAGS += -m32
DEFINE_VALS += -D_32BIT_
endif
ifeq ($(MULTICORE), TRUE)
DEFINE_VALS += -DMULTICORE
endif

.PHONY: startM
startM:
	@echo -e "$(SECTIONC)[build]$(INFOC) Compiling synos for target $(ARCH) using $(LOAD_SYSTEM)...$(NC)"

.PHONY: initimg
initimg: $(MODULES)
	@echo -e "$(SECTIONC)[initimg] $(LINKC)Linking object files -> $(INITIMG_PREFIX)/synos$(NC)"
	@$(LINK) $(LINK_ARGS) -T $(IMG_LINK) $(INITIMGOBJECTS) -o $(INITIMG_PREFIX)/synos

.PHONY: clean
clean:
	@find . -name "*.o" -type f -delete

.PHONY: grub
grub:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing synos along with GRUB to iso file $(INSTALL_DRIVE)...$(NC)"
	@mkdir -p $(ROOT_DIR)/boot/grub
	@cp conf/GRUB2.cfg.default $(ROOT_DIR)/boot/grub/grub.cfg
	@cp $(INITIMG_PREFIX)/synos $(ROOT_DIR)/boot/synos
	@grub-mkrescue -o synos.iso $(ROOT_DIR)
	@rm -rf $(ROOT_DIR)
	@echo -e "$(SECTIONC)[install]$(INFOC) $(INSTALL_DRIVE) created!$(NC)"
qemu:
	@echo -e "$(SECTIONC)[qemu]$(INFOC) Starting qemu with command: qemu-system-x86_64 -cdrom $(INSTALL_DRIVE) -gdb tcp::9000 -S -monitor stdio $(QEMU_ARGS)$(NC)"
	@qemu-system-x86_64 -cdrom $(INSTALL_DRIVE) -gdb tcp::9000 -S -monitor stdio

.PHONY: install
install:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing synos to $(INSTALL_DIR)/synos ...$(NC)"
	@cp $(ROOT_DIR)/boot/synos $(INSTALL_DIR)/synos
	@chmod 644 $(INSTALL_DIR)/synos
	@echo -e "$(SECTIONC)[install]$(INFOC) Done!$(NC)"