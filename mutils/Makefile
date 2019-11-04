MUTDIR=mutils
MUTDIR_FULL=$(SOURCE_DIR)/mutils

INITIMGOBJECTS += $(SOURCE_DIR)/mutils/mutils.o

MUTILSOBJECTS=

include mutils/stdio/Makefile

mutils: $(MUTILSOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking mutils object files -> mutils/mutils.o$(NC)"
	@$(LINK) -r $(MUTILSOBJECTS) -o mutils/mutils.o