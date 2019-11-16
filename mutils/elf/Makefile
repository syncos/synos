ELFDIR=$(MUTDIR)/elf
ELFDIR_FULL=$(MUTDIR_FULL)/elf

MUTILSOBJECTS += $(MUTDIR)/elf.o

ELFOBJECTS += $(ELFDIR)/elf.o $(ELFDIR)/header.o

$(MUTDIR)/elf.o: $(ELFOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking elf object files -> $(MUTDIR)/elf.o$(NC)"
	@$(LINK) -r $(ELFOBJECTS) -o $(MUTDIR)/elf.o