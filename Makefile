include .global
include .config

MODULES=startM
INITIMGOBJECTS=


include arch/Makefile
include kernel/Makefile
include drivers/Makefile
include mutils/Makefile

# Add modules
MODULES += kernel arch mutils drivers

.PHONY: all
all: initimg

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
	@echo -e "$(SECTIONC)[build]$(INFOC) Compiling mkos for target $(ARCH) using $(LOAD_SYSTEM)...$(NC)"

.PHONY: initimg
initimg: $(MODULES)
	@echo -e "$(SECTIONC)[initimg] $(LINKC)Linking object files -> $(INITIMG_PREFIX)/mkos$(NC)"
	@$(LINK) $(LINK_ARGS) -T $(IMG_LINK) $(INITIMGOBJECTS) -o $(INITIMG_PREFIX)/mkos

.PHONY: clean
clean:
	@find . -name "*.o" -type f -delete

.PHONY: grub
grub:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing mkos along with GRUB to iso file $(INSTALL_DRIVE)...$(NC)"
	@mkdir -p $(ROOT_DIR)/boot/grub
	@cp conf/GRUB2.cfg.default $(ROOT_DIR)/boot/grub/grub.cfg
	@cp $(INITIMG_PREFIX)/mkos $(ROOT_DIR)/boot/mkos
	@grub-mkrescue -o mkos.iso $(ROOT_DIR)
	@rm -rf $(ROOT_DIR)
	@echo -e "$(SECTIONC)[install]$(INFOC) $(INSTALL_DRIVE) created!$(NC)"
qemu:
	@echo -e "$(SECTIONC)[qemu]$(INFOC) Starting qemu with command: qemu-system-x86_64 -cdrom $(INSTALL_DRIVE) -gdb tcp::9000 -S -monitor stdio $(QEMU_ARGS)$(NC)"
	@qemu-system-x86_64 -cdrom $(INSTALL_DRIVE) -gdb tcp::9000 -S -monitor stdio

.PHONY: install
install:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing mkos to $(INSTALL_DIR)/mkos ...$(NC)"
	@cp $(ROOT_DIR)/boot/mkos $(INSTALL_DIR)/mkos
	@chmod 644 $(INSTALL_DIR)/mkos
	@echo -e "$(SECTIONC)[install]$(INFOC) Done!$(NC)"