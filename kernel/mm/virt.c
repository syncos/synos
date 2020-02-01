#include <synos/mm.h>
#include <synos/arch/memory.h>

void *next_free_vpage;

static void *fnfp(void *nfp)
{
    for (void *addr = nfp; ; addr += virt_page_size)
    {
        if (!pga_ispresent(addr))
            return addr;
    }
}

int vpage_init()
{
    pga_init();
    pga_map(0, 0, 0, VPAGE_NOT_WRITABLE | VPAGE_NO_EXECUTE);

    next_free_vpage = fnfp((void*)0x100000);
    return 0;
}

void *vpage_map(uintptr_t paddress, unsigned int flags)
{
    pga_map(next_free_vpage, paddress, 0, flags);
    void *addr = next_free_vpage;
    next_free_vpage = fnfp(next_free_vpage);
    return addr;
}
void *vpages_map(uintptr_t paddress, unsigned int order, unsigned int flags)
{
    for (uintptr_t start = (uintptr_t)next_free_vpage; start < __UINTPTR_MAX__; start += virt_page_size) 
    {
        for (uintptr_t pgs = start; (pgs - start) / virt_page_size < (1UL << order); pgs += virt_page_size)
        {
            if (pga_ispresent((void*)pgs))
                goto nav;
        }
        pga_map((void*)start, paddress, order, flags);
        return (void*)start;
        nav:
        continue;
    }
    return NULL;
}
void *vpage_smap(uintptr_t paddress, void *vaddress, unsigned int flags)
{
    pga_map(vaddress, paddress, 0, flags);
    return vaddress;
}
void *vpages_smap(uintptr_t paddress, void *vaddress, unsigned int order, unsigned int flags)
{
    pga_map(vaddress, paddress, order, flags);
    return vaddress;
}
void *vpages_reserve(void *vaddress, unsigned int order)
{
    pga_map(vaddress, 0, order, VPAGE_NOT_WRITABLE);
    return vaddress;
}

void vpage_unmap(void *vaddress)
{
    pga_unmap(vaddress, 0);
}
void vpages_unmap(void *vaddress, unsigned int order)
{
    pga_unmap(vaddress, order);
}