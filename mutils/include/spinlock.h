#ifndef IMPL_SPINLOCK_H
#define IMPL_SPINLOCK_H

extern int  atomic_compare_exchange(int *ptr, int compare, int exchange);
extern void atomic_store(int *ptr, int value);

void spinlock_lock(int *lock);
void spinlock_unlock(int *lock);

#endif