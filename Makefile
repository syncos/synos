include .global

ifeq (, $(wildcard ./.config))
$(error .config not found!)
endif
include .config

MODULES=startM
INITIMGOBJECTS=

.PHONY: all
all: $(KERNEL_OUT)

include arch/Makefile
include kernel/Makefile
include modules/Makefile
include utils/Makefile

# Add modules
MODULES += kernel arch modules utils

ifeq ($(TARGET), DEBUG)
DEBUG=TRUE
OPTIMIZE=FALSE
DEFINE_VALS += -DTARGET=\"DEBUG\"
endif
ifeq ($(TARGET), RELEASE)
DEBUG=FALSE
DEFINE_VALS += -DTARGET=\"RELEASE\"
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
DEFINE_VALS += -DDDEBUG
endif
ifdef LOGLEVEL
DEFINE_VALS += -DLOGLEVEL=$(LOGLEVEL)
endif

.PHONY: startM
startM:
	@echo -e "$(SECTIONC)[build]$(INFOC) Compiling synos for target $(ARCH)...$(NC)"

$(KERNEL_OUT): $(MODULES)
	@echo -e "$(SECTIONC)[initimg] $(LINKC)Linking object files -> $(KERNEL_OUT)$(NC)"
	@$(LINK) -T $(IMG_LINK) $(INITIMGOBJECTS) -o $(KERNEL_OUT) $(LINK_FLAGS)
	@echo -e "$(SECTIONC)[build]$(INFOC) Build done!$(NC)"

.PHONY: clean
clean:
	@find . -name "*.o" -type f -delete
	@rm -f synos
	@rm -f synos.iso
	@rm -f synos.map