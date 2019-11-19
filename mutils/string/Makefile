STRINGDIR=$(MUTDIR)/string
STRINGDIR_FULL=$(MUTDIR_FULL)/string

MUTILSOBJECTS += $(MUTDIR)/string.o

STRINGOBJECTS=$(STRINGDIR)/strlen.o $(STRINGDIR)/tostring.o $(STRINGDIR)/reverse.o $(STRINGDIR)/memcpy.o $(STRINGDIR)/memset.o $(STRINGDIR)/strcmp.o $(STRINGDIR)/c_str.o

$(MUTDIR)/string.o: $(STRINGOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking stdio object files -> $(MUTDIR)/string.o$(NC)"
	@$(LINK) -r $(STRINGOBJECTS) -o $(MUTDIR)/string.o