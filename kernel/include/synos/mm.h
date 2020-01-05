#ifndef K_MM_H
#define K_MM_H
#include <synos/arch/memory.h>

#ifndef MAX_ORDER
#define MAX_ORDER 16
#endif

struct block;
typedef struct page
{
    uintptr_t addr;
    void* start;
}page_t;
typedef struct block
{
    unsigned int order;

    page_t *page_start;
    page_t *page_end;
}block_t;

typedef struct block_list_struct
{
    unsigned int order;
    size_t block_count;
    block_t* blocks;
}block_list_t;

extern struct arch_page_size PS;
extern block_list_t free_area[];

int mm_init();
int ppage_init();

page_t getPhysPage(size_t index);

#endif