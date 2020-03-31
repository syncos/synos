#ifndef ARCH_H
#define ARCH_H

enum ARCH
{
    X86,
    X86_64,
};
extern const enum ARCH arch;

extern void halt();

#endif