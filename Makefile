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
LINK_FLAGS += -O2
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
	@$(LINK) -T $(IMG_LINK) $(INITIMGOBJECTS) -o $(INITIMG_PREFIX)/synos $(LINK_FLAGS)

.PHONY: clean
clean:
	@find . -name "*.o" -type f -delete
	@rm -f synos
	@rm -f synos.iso
	@rm -f synos.map