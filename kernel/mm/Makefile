MMDIR=kernel/mm
KERNOBJECTS += kernel/mm/mm.o kernel/mm/phys.o kernel/mm/memstack.o kernel/mm/virt.o

ifdef USE_BMP_ALLOCATOR
include $(MMDIR)/bmp/Makefile
else
ifdef USE_BPA_ALLOCATOR
include $(MMDIR)/bpa/Makefile
else
$(error No page allocator specified!)
endif
endif