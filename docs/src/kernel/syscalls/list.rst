List over syscalls
==================

Here is a list of all the stock syscalls and what they do. Keep in mind that the syscall id's may change depending on the configuration.
Because of that, it is strongly advised to the values provided by the SYSCALL_INDEX enum class in `synos/syscall.h`.

**This list is a WIP, which means the information may change drastically**

SYSCALL_EXT [0]:
    **Description**

    Exit program. It is recommended to use this syscall instead of just returning from the _start function
    with the return value.

    **Args**
        0 : int = return value
SYSCALL_EOX [1]:
    **Description**

    Pass back execution to the kernel. Can be used by programs to voluntarily give up execution back to the scheduler. 
    It is recommended to use this syscall instead of irq 0.

    **Args**
        None
SYSCALL_SYC [2]:
    **Description**

    Kernel syscall management. Consists of different functions to add, remove, and modify how syscalls behave.
    If the caller has a priveledge level over 0, the function will return an error.

    **Args**
        *WIP*
SYSCALL_MEM [3]:
    **Description**

    Memory functions. 
    Provides various functions for allocating and freeing memory, and provides memory management functions for level 0 programs.

    **Args**
        *WIP*