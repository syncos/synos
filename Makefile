include .config

MODULES=startM
INITIMGOBJECTS=

.PHONY: startM
.PHONY: all
.PHONY: clean
.PHONY: initimg
.PHONY: grub


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

all: $(MODULES)

startM:
	@echo -e "$(SECTIONC)[build]$(INFOC) Compiling mkos for target $(ARCH) using $(LOAD_SYSTEM)...$(NC)"
initimg:
	@echo -e "$(SECTIONC)[initimg] $(LINKC)Linking object files -> $(ROOT_DIR)/boot/mkos$(NC)"
	@mkdir -p $(ROOT_DIR)/boot
	@$(LINK) $(LINK_ARGS) -T $(IMG_LINK) $(INITIMGOBJECTS) -o $(ROOT_DIR)/boot/mkos

clean:
	@find . -name "*.o" -type f -delete

grub:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing mkos along with GRUB to iso file $(INSTALL_DRIVE)...$(NC)"
	@mkdir -p $(ROOT_DIR)/boot/grub
	@cp conf/GRUB2.cfg.default $(ROOT_DIR)/boot/grub/grub.cfg
	@grub-mkrescue -o mkos.iso $(ROOT_DIR)
