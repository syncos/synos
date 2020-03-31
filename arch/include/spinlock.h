#ifndef SPINLOCK_H
#define SPINLOCK_H

extern int atomic_cmp_xchg(int * lock, int compare, int exchange);
extern void atomic_store(int * lock, int value);

#define spinlock_lock(lock) while (!atomic_cmp_xchg(lock, 0, 1)) {}
#define spinlock_unlock(lock) atomic_store(lock, 0)

#endif