include .config

MODULES=startM
INITIMGOBJECTS=

.PHONY: startM
.PHONY: all
.PHONY: clean
.PHONY: initimg
.PHONY: grub
.PHONY: install
.PHONY: mutils

include arch/Makefile
include kernel/Makefile
include drivers/Makefile
include mutils/Makefile

# Add modules
ifeq ($(BUILD_KERNEL), TRUE)
MODULES += arch kernel mutils
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

ifeq ($(BUILD_TYPE), DEBUG)
DEBUG=TRUE
OPTIMIZE=FALSE
endif
ifeq ($(BUILD_TYPE), RELEASE)
DEBUG=FALSE
OPTIMIZE=TRUE
endif
ifeq ($(ASSEMBLY), TRUE)
CC_FLAGS += -S
CXX_FLAGS += -S
endif
ifeq ($(DEBUG), TRUE)
CC_FLAGS += -g
CXX_FLAGS += -g
ASM_FLAGS += -g
LINK_FLAGS += -g
endif
ifeq ($(OPTIMIZE), TRUE)
CC_FLAGS += -O2
CXX_FLAGS += -O2
ASM_FLAGS += -O2
LINK_FLAGS += -O
endif
ifeq ($(BITS), 64)
CC_FLAGS += -m64
CXX_FLAGS += -m64
else
CC_FLAGS += -m32
CXX_FLAGS += -m32
endif

startM:
	@echo -e "$(SECTIONC)[build]$(INFOC) Compiling mkos for target $(ARCH) using $(LOAD_SYSTEM)...$(NC)"
	@echo -e "$(SECTIONC)[build]$(INFOC) Modules staged for compilation: $(MODULES)$(NC)"
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
install:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing mkos to $(INSTALL_DIR)/mkos ...$(NC)"
	@cp $(ROOT_DIR)/boot/mkos $(INSTALL_DIR)/mkos
	@chmod 644 $(INSTALL_DIR)/mkos
	@echo -e "$(SECTIONC)[install]$(INFOC) Done!$(NC)"