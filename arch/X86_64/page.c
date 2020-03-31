#include <arch/memory.h>
#include <mm.h>

extern volatile unsigned long __KERNEL_START[];
extern volatile unsigned long __KERNEL_END[];

const unsigned long KERNEL_START = (unsigned long)__KERNEL_START;
const unsigned long KERNEL_END   = (unsigned long)__KERNEL_END;

const unsigned long page_size = 0x1000;
const unsigned long page_align = 0x1000;

static inline unsigned long kpage_table_address (void * vaddress, unsigned int level)
{
    unsigned long table_address = ((unsigned long)vaddress >> (9*level));
    table_address &= ~(7UL);
    for (unsigned int i = 0; i < level; ++i)
        table_address |= (511UL << (39-(9*i)));
    if ((table_address >> 47) & 1U)
        table_address |= (0xFFFFUL << 48);
    else
        table_address &= ~(0xFFFFUL << 48);
    return table_address;
}
static int kpage_ispresent (void * vaddress, unsigned int level)
{
    if (level <= 0 || level > 4)
        return 0;
    if (level < 4)
        if (!kpage_ispresent(vaddress, level+1))
            return 0;
    
    unsigned long table_address = kpage_table_address(vaddress, level);
    if (*((unsigned long*)table_address) & 1U)
        return 1;
    return 0;
}
int kpage_present (void * vaddress)
{
    return kpage_ispresent(vaddress, 1);
}

static void kpage_table_alloc(unsigned int level, void * vaddress)
{
    if (level <= 0 || level > 4)
        return;
    if (level < 4 && !kpage_ispresent(vaddress, level + 1)) {
        kpage_table_alloc(level + 1, vaddress);
        if (!kpage_ispresent(vaddress, level + 1))
            return;
    }

    unsigned long entry = ppages_alloc(0);
    if (!entry)
        return;
    
    entry |= 0b11;
    unsigned long table_address = kpage_table_address(vaddress, level);

    *(unsigned long*)table_address = entry;
    return;
}
void * kpage_map (void * vaddress, unsigned long paddress, unsigned int flags)
{
    unsigned long entry = 1;
    if (flags & PAGE_WRITABLE)
        entry |= 0b10;
    if (flags & PAGE_USER_ACCESS)
        entry |= 0b100;
    if (flags & PAGE_NO_CACHE)
        entry |= 0b1000;
    if (!(flags & PAGE_EXECUTE))
        entry |= (1UL << 63);
    
    if (!kpage_ispresent(vaddress, 2)) {
        kpage_table_alloc(2, vaddress);
        if (!kpage_ispresent(vaddress, 2))
            return NULL;
    }
    
    entry = (paddress & ~((0xFFFUL << 52) | 0xFFFUL)) + (entry & ((0xFFFUL << 52) | 0xFFFUL));
    unsigned long table_address = kpage_table_address(vaddress, 1);

    *(unsigned long *)table_address = entry;

    return vaddress;
}
void kpage_unmap (void * vaddress)
{
    if (!kpage_ispresent(vaddress, 1))
        return;
    
    unsigned long table_address = kpage_table_address(vaddress, 1);

    *(unsigned long *)table_address = 0;
}

static unsigned long kpage_info (void * vaddress, unsigned int level)
{
    unsigned long table_address = kpage_table_address(vaddress, level);
    return *(unsigned long *)table_address;
}
unsigned long kpage_paddr (void * vaddress)
{
    unsigned long pinfo = kpage_info(vaddress, 1);

    pinfo &= ~(0xFFFUL); // Remove everything else except the physical address
    pinfo &= ~(0xFFFUL << 52);

    return pinfo;
}