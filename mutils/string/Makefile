STRINGDIR=$(MUTDIR)/string
STRINGDIR_FULL=$(MUTDIR_FULL)/string

MUTILSOBJECTS += $(MUTDIR)/string.o

STRINGOBJECTS=$(STRINGDIR)/strlen.o $(STRINGDIR)/tostring.o $(STRINGDIR)/reverse.o $(STRINGDIR)/memcpy.o $(STRINGDIR)/strcmp.o $(STRINGDIR)/c_str.o

$(MUTDIR)/string.o: $(STRINGOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking stdio object files -> $(MUTDIR)/string.o$(NC)"
	@$(LINK) -r $(STRINGOBJECTS) -o $(MUTDIR)/string.o

$(STRINGDIR)/strlen.o: $(STRINGDIR)/strlen.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/strlen.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/strlen.c -o $(STRINGDIR)/strlen.o
	
$(STRINGDIR)/tostring.o: $(STRINGDIR)/tostring.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/tostring.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/tostring.c -o $(STRINGDIR)/tostring.o

$(STRINGDIR)/c_str.o: $(STRINGDIR)/c_str.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/c_str.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/c_str.c -o $(STRINGDIR)/c_str.o

$(STRINGDIR)/reverse.o: $(STRINGDIR)/reverse.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/reverse.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/reverse.c -o $(STRINGDIR)/reverse.o

$(STRINGDIR)/memcpy.o: $(STRINGDIR)/memcpy.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/memcpy.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/memcpy.c -o $(STRINGDIR)/memcpy.o

$(STRINGDIR)/strcmp.o: $(STRINGDIR)/strcmp.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(STRINGDIR)/strcmp.o$(NC)"
	@$(CC) $(CC_FLAGS) $(STRINGDIR)/strcmp.c -o $(STRINGDIR)/strcmp.o