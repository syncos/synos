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

all: $(MODULES)

startM:
	@echo -e "$(SECTIONC)[build]$(INFOC) Compiling newlix for target $(ARCH) using $(LOAD_SYSTEM)...$(NC)"
initimg:
	@echo -e "$(SECTIONC)[initimg] $(LINKC)Linking object files -> newlix.img$(NC)"
	@$(LINK) $(LINK_ARGS) -T $(IMG_LINK) $(INITIMGOBJECTS) -o newlix.img

clean:
	@find . -name "*.o" -type f -delete