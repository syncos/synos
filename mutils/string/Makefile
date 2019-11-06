STRINGDIR=$(MUTDIR)/string
STRINGDIR_FULL=$(MUTDIR_FULL)/string

MUTILSOBJECTS += $(MUTDIR)/string.o

STRINGOBJECTS=$(STRINGDIR)/strlen.o $(STRINGDIR)/tostring.o $(STRINGDIR)/reverse.o

$(MUTDIR)/string.o: $(STRINGOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking stdio object files -> $(MUTDIR)/string.o$(NC)"
	@$(LINK) -r $(STRINGOBJECTS) -o $(MUTDIR)/string.o

$(STRINGDIR)/strlen.o: $(STRINGDIR)/strlen.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/strlen.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/strlen.c -o $(STRINGDIR)/strlen.o
	
$(STRINGDIR)/tostring.o: $(STRINGDIR)/tostring.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/tostring.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/tostring.c -o $(STRINGDIR)/tostring.o

$(STRINGDIR)/reverse.o: $(STRINGDIR)/reverse.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/reverse.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/reverse.c -o $(STRINGDIR)/reverse.o