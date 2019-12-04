STDLIBDIR=$(MUTDIR)/stdlib
STDLIBDIR_FULL=$(MUTDIR_FULL)/stdlib

MUTILSOBJECTS += $(MUTDIR)/stdlib.o

STDLIBOBJECTS += $(STDLIBDIR)/malloc.o

$(MUTDIR)/stdlib.o: $(STDLIBOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking stdlib object files -> $(MUTDIR)/stdlib.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(STDLIBOBJECTS) -o $(MUTDIR)/stdlib.o