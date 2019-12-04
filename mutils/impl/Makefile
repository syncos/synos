IMPLDIR=$(MUTDIR)/impl
STDIODIR_FULL=$(MUTDIR_FULL)/impl

MUTILSOBJECTS += $(MUTDIR)/impl.o

IMPLOBJECTS=$(IMPLDIR)/stdio.o

$(MUTDIR)/impl.o: $(IMPLOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking impl object files -> $(MUTDIR)/impl.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(IMPLOBJECTS) -o $(MUTDIR)/impl.o