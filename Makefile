include config.mk

MODULES=startM
INITIMGOBJECTS=

.PHONY: startM
.PHONY: all
.PHONY: clean
.PHONY: initimg


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

startM:
	@echo -e "$(SECTIONC)[build]$(INFOC) Compiling newlix for target $(ARCH) using $(LOAD_SYSTEM)...$(NC)"
initimg:
	@mkdir -p $(ROOT_DIR)/boot/
	@echo -e "$(SECTIONC)[initimg] $(LINKC)Linking object files -> $(ROOT_DIR)/boot/newlix.img$(NC)"

all: $(MODULES)

clean:
	@find . -name "*.o" -type f -delete