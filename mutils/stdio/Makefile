STDIODIR=$(MUTDIR)/stdio
STDIODIR_FULL=$(MUTDIR_FULL)/stdio

MUTILSOBJECTS += $(MUTDIR)/stdio.o

STDIOOBJECTS += $(STDIODIR)/stdin.o $(STDIODIR)/stdout.o $(STDIODIR)/stderr.o $(STDIODIR)/clearerr.o

$(MUTDIR)/stdio.o: $(STDIOOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking stdio object files -> $(MUTDIR)/stdio.o$(NC)"
	@$(LINK) -r $(STDIOOBJECTS) -o $(MUTDIR)/stdio.o

$(STDIODIR)/stdin.o: $(STDIODIR)/stdin.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STDIODIR)/stdin.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STDIODIR)/stdin.c -o $(STDIODIR)/stdin.o

$(STDIODIR)/stdout.o: $(STDIODIR)/stdout.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STDIODIR)/stdout.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STDIODIR)/stdout.c -o $(STDIODIR)/stdout.o

$(STDIODIR)/stderr.o: $(STDIODIR)/stderr.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STDIODIR)/stderr.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STDIODIR)/stderr.c -o $(STDIODIR)/stderr.o

$(STDIODIR)/clearerr.o: $(STDIODIR)/clearerr.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STDIODIR)/clearerr.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STDIODIR)/clearerr.c -o $(STDIODIR)/clearerr.o