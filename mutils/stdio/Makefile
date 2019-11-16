STDIODIR=$(MUTDIR)/stdio
STDIODIR_FULL=$(MUTDIR_FULL)/stdio

MUTILSOBJECTS += $(MUTDIR)/stdio.o

STDIOOBJECTS += $(STDIODIR)/stdin.o $(STDIODIR)/stdout.o $(STDIODIR)/stderr.o $(STDIODIR)/clearerr.o $(STDIODIR)/fclose.o $(STDIODIR)/feof.o $(STDIODIR)/ferror.o $(STDIODIR)/fflush.o $(STDIODIR)/printf.o

$(MUTDIR)/stdio.o: $(STDIOOBJECTS)
	@echo -e "$(SECTIONC)[mutils] $(LINKC)Linking stdio object files -> $(MUTDIR)/stdio.o$(NC)"
	@$(LINK) -r $(STDIOOBJECTS) -o $(MUTDIR)/stdio.o