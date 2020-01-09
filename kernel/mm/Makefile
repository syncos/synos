MMDIR=kernel/mm
KERNOBJECTS += kernel/mm/mm.o kernel/mm/phys.o kernel/mm/memstack.o

ifdef USE_BMP_ALLOCATOR
include $(MMDIR)/bmp/Makefile
else
$(error No page allocator specified!)
endif