ELFDIR=$(MUTDIR)/elf
ELFDIR_FULL=$(MUTDIR_FULL)/elf

MUTILSOBJECTS += $(MUTDIR)/elf.o

ELFOBJECTS += $(ELFDIR)/elf.o $(ELFDIR)/header.o

$(MUTDIR)/elf.o: $(ELFOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking elf object files -> $(MUTDIR)/elf.o$(NC)"
	@$(LINK) -r $(ELFOBJECTS) -o $(MUTDIR)/elf.o

$(ELFDIR)/elf.o: $(ELFDIR)/elf.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(ELFDIR)/elf.o$(NC)"
	@$(CC) $(CC_FLAGS) $(ELFDIR)/elf.c -o $(ELFDIR)/elf.o

$(ELFDIR)/header.o: $(ELFDIR)/header.c
	@echo -e "$(SECTIONC)[mutils] $(COMPILEC)Compiling C object $(ELFDIR)/header.o$(NC)"
	@$(CC) $(CC_FLAGS) $(ELFDIR)/header.c -o $(ELFDIR)/header.o