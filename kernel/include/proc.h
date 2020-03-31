#ifndef PROC_H
#define PROC_H

struct proc;
struct thread;
struct address_space
{
    void *              root;
    unsigned long       root_physical;
    struct proc *       owner;
    struct proc **      members;
    unsigned int        flags;
};
typedef struct address_space address_space_t;
#define ADDRESS_SPACE_FLAGS_KERNEL  1
#define ADDRESS_SPACE_FLAGS_SHARED  2
#define ADDRESS_SPACE_FLAGS_MAIN    4
#define ADDRESS_SPACE_FLAGS_INHERIT 8

struct proc
{
    char *                  name;
    unsigned int            pid;
    unsigned int            priority;
    struct address_space *  address_space;
    struct thread **        threads;
    unsigned int            flags;
};
typedef struct proc proc_t;
#define PROC_FLAGS_KERNEL 1
#define PROC_FLAGS_MODULE 2

struct thread
{
    struct proc * parent;
    unsigned int priority;
    void * state_properties;
};
typedef struct thread thread_t;

extern address_space_t ** address_spaces;
extern proc_t          ** proclist;
#endif