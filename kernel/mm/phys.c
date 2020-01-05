#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>

block_list_t free_area[MAX_ORDER];

int ppage_init()
{
    for (int i = MAX_ORDER - 1; i >= 0; --i)
    {
        free_area[i].order = i;
        free_area[i].block_count = 0;
        free_area[i].blocks = NULL;
    }
}

page_t getPhysPage(size_t index)
{
    page_t pgs;
    pgs.addr = phys_page_size * index;
    pgs.start = (void*)pgs.addr;
    return pgs;
}