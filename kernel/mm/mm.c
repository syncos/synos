#include <synos/synos.h>
#include <synos/mm.h>

int mm_init()
{
    vpage_init();
    ppage_init();

    return 0;
}

void* kmalloc(size_t bytes)
{
    if (!System.MMU_enabled)
    {
        return memstck_malloc(bytes);
    }
    return NULL;
}
void kfree(void* pointer)
{
    if (!System.MMU_enabled)
    {
        return;
    }
    return;
}