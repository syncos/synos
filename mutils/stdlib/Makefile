STDLIBDIR=$(MUTDIR)/stdlib
STDLIBDIR_FULL=$(MUTDIR_FULL)/stdlib

MUTILSOBJECTS += $(MUTDIR)/stdlib.o

STDLIBOBJECTS += $(STDLIBDIR)/malloc.o

$(MUTDIR)/stdlib.o: $(STDLIBOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking stdlib object files -> $(MUTDIR)/stdlib.o$(NC)"
	@$(LINK) -r $(STDLIBOBJECTS) -o $(MUTDIR)/stdlib.o

$(STDLIBDIR)/malloc.o: $(STDLIBDIR)/malloc.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STDLIBDIR)/malloc.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STDLIBDIR)/malloc.c -o $(STDLIBDIR)/malloc.o