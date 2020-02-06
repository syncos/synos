MUTDIR=mutils
MUTDIR_FULL=$(SOURCE_DIR)/mutils

INITIMGOBJECTS += $(SOURCE_DIR)/mutils/mutils.o

MUTILSOBJECTS=

include mutils/impl/Makefile
include mutils/string/Makefile
include mutils/elf/Makefile

.PHONY: mutils
mutils: mutils/mutils.o
mutils/mutils.o: $(MUTILSOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking mutils object files -> mutils/mutils.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(MUTILSOBJECTS) -o mutils/mutils.o

$(MUTDIR)/%.o: $(MUTDIR)/%.c
	@$(CC) $(CC_FLAGS) $< -o $@
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $@$(NC)"