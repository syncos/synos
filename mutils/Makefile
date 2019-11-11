MUTDIR=mutils
MUTDIR_FULL=$(SOURCE_DIR)/mutils

INITIMGOBJECTS += $(SOURCE_DIR)/mutils/mutils.o

MUTILSOBJECTS=

include mutils/stdio/Makefile
include mutils/impl/Makefile
include mutils/string/Makefile
include mutils/stdatomic/Makefile
include mutils/stdlib/Makefile

.PHONY: mutils
mutils: $(MUTILSOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking mutils object files -> mutils/mutils.o$(NC)"
	@$(LINK) -r $(MUTILSOBJECTS) -o mutils/mutils.o