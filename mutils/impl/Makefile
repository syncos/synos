IMPLDIR=$(MUTDIR)/impl
STDIODIR_FULL=$(MUTDIR_FULL)/impl

MUTILSOBJECTS += $(MUTDIR)/impl.o

IMPLOBJECTS=$(IMPLDIR)/stdio.o

$(MUTDIR)/impl.o: $(IMPLOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking impl object files -> $(MUTDIR)/impl.o$(NC)"
	@$(LINK) -r $(IMPLOBJECTS) -o $(MUTDIR)/impl.o

$(IMPLDIR)/stdio.o: $(IMPLDIR)/stdio.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(IMPLDIR)/stdio.o$(NC)"
	@$(CC) $(CC_FLAGS) $(IMPLDIR)/stdio.c -o $(IMPLDIR)/stdio.o