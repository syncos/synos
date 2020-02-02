#include <synos/synos.h>
#include <synos/mm.h>
#include <string.h>

mstack_t* alloc_stack;
size_t alloc_stack_l;
size_t alloc_stack_f;
size_t alloc_stack_p;

mframe_t* kframes;
size_t kframes_p;
size_t kframes_alloc_l;
size_t kframes_f;

bool MemStack_init = false;
bool MemStack_enable = true;
uintptr_t MemStack;

int mm_init()
{
    vpage_init();
    ppage_init();
    
    alloc_stack        = get_free_page(GFP_KERNEL);
    alloc_stack_l      = 1;
    alloc_stack_f      = 0;
    alloc_stack_p      = 0;

    kframes            = get_free_page(GFP_KERNEL);
    kframes_p          = 0;
    kframes_alloc_l    = 1;
    kframes_f          = 0;

    System.MMU_enabled = true;
    memstck_disable();

    return 0;
}
void *__get_free_page(unsigned int gfp_mask)
{
    uintptr_t page_address = alloc_page(gfp_mask);
    if (!page_address)
        return NULL;
    return vpage_map(page_address, 0);
}
void *__get_free_pages(unsigned int gfp_mask, unsigned int order)
{
    uintptr_t pages_address = alloc_pages(gfp_mask, order);
    if (!pages_address)
        return NULL;
    return vpages_map(pages_address, order, 0);
}
void *get_free_page(unsigned int gfp_mask)
{
    void *mem = __get_free_page(gfp_mask);
    memset(mem, 0, virt_page_size);
    return mem;
}

void* kmalloc(size_t bytes)
{
    if (!System.MMU_enabled)
    {
        return memstck_malloc(bytes);
    }

    mframe_t *frame;
    for (size_t i = kframes_f; i <= kframes_p; ++i)
    {
        if (i == kframes_p) {
            if (kframes_p >= (virt_page_size * kframes_alloc_l) / sizeof(mframe_t)) {
                // Resize the kframes array
                unsigned int oldorder = log_order(kframes_alloc_l);
                unsigned int neworder = log_order(++kframes_alloc_l);
                kframes_alloc_l = (1UL << neworder);

                mframe_t* new_kframes = __get_free_pages(GFP_KERNEL, neworder);
                memcpy(new_kframes, kframes, sizeof(mframe_t)*kframes_p);
                
                free_pages(oldorder, pga_getPhysAddr(kframes));
                vpages_unmap(kframes, oldorder);

                kframes = new_kframes;
            }
            kframes[i].present = true;
            kframes[i].order = log_order((bytes + (virt_page_size - 1)) / virt_page_size);
            kframes[i].frame = __get_free_pages(GFP_KERNEL, kframes[i].order);
            memset(kframes[i].frame, 0, (1UL << kframes[i].order)*virt_page_size);
            kframes[i].pointer = 0;

            ++kframes_p;
            frame = &kframes[i];
            break;
        }
        if (kframes[i].present && (virt_page_size * (1UL << kframes[i].order)) - kframes[i].pointer >= bytes) {
            frame = &kframes[i];
            break;
        }
    }

    if (alloc_stack_p >= (virt_page_size * alloc_stack_l) / sizeof(mstack_t)) {
        // Resize the alloc_stack array
        unsigned int oldorder = log_order(alloc_stack_l);
        unsigned int neworder = log_order(++alloc_stack_l);
        alloc_stack_l = (1UL << neworder);

        mstack_t* new_alloc_stack = __get_free_pages(GFP_KERNEL, neworder);
        memset(new_alloc_stack, 0, (1UL << neworder)*virt_page_size);
        memcpy(new_alloc_stack, alloc_stack, sizeof(mstack_t)*alloc_stack_p);
                
        free_pages(oldorder, pga_getPhysAddr(alloc_stack));
        vpages_unmap(alloc_stack, oldorder);

        alloc_stack = new_alloc_stack;
    }

    void *address = frame->frame + frame->pointer;

    alloc_stack[alloc_stack_f].present = true;
    alloc_stack[alloc_stack_f].address = address;
    alloc_stack[alloc_stack_f].length = bytes;
    ++alloc_stack_p;

    for (size_t i = alloc_stack_f+1; i < (virt_page_size * alloc_stack_l) / sizeof(mstack_t); ++i)
    {
        if (!alloc_stack[i].present) {
            alloc_stack_f = i;
            break;
        }
    }

    frame->pointer += bytes;

    return address;
}
void kfree(void* pointer)
{
    if (!System.MMU_enabled)
    {
        return;
    }
    return;
}

void* memstck_malloc(size_t bytes)
{
    if (!MemStack_enable)
        return NULL;
    if (!MemStack_init)
    {
        MemStack = _MemEnd + 64; // Padding just in case
        MemStack_init = true;
    }
    if (MemStack >= 0x200000)
    {
        MemStack_enable = false;
        return NULL;
    }
    if (MemStack + bytes >= 0x200000)
        return NULL;
    void* pointer = (void*)MemStack;

    MemStack += bytes + 1;
    ((char*)pointer)[bytes] = 0;

    return pointer;
}

void memstck_disable()
{
    MemStack_enable = false;
}