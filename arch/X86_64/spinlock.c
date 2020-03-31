#include <spinlock.h>

int atomic_cmp_xchg(int * lock, int compare, int exchange)
{
    return __atomic_compare_exchange_n(lock, &compare, exchange, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
}
void atomic_store(int * lock, int value)
{
    __atomic_store_n(lock, value, __ATOMIC_SEQ_CST);
}