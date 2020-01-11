#include <spinlock.h>

inline void spinlock_lock(int *lock)
{
    while (!atomic_compare_exchange(lock, 0, 1)) {}
}
inline void spinlock_unlock(int *lock)
{
    atomic_store(lock, 0);
}
int atomic_compare_exchange(int *ptr, int compare, int exchange)
{
    return __atomic_compare_exchange_n(ptr, &compare, exchange, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
}
void atomic_store(int* ptr, int value)
{
    __atomic_store_n(ptr, value, __ATOMIC_SEQ_CST);
}