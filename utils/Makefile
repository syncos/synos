UTDIR=utils
UTDIR_FULL=$(SOURCE_DIR)/utils

INITIMGOBJECTS += $(SOURCE_DIR)/utils/utils.o

UTILSOBJECTS=utils/string.o

.PHONY: utils
utils: utils/utils.o
utils/utils.o: $(UTILSOBJECTS)
	@echo -e "$(SECTIONC)[utils] $(LINKC)Linking utils object files -> utils/utils.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(UTILSOBJECTS) -o utils/utils.o
$(UTDIR)/%.o: $(UTDIR)/%.c
	@$(CC) $(CC_FLAGS) $< -o $@
	@echo -e "$(SECTIONC)[utils] $(COMPILEC)Compiling C object $@$(NC)"