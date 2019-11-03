#ifndef _UTILS_H
#define _UTILS_H
#include <inttypes.h>

extern int stack_push(regmax_t _value);
extern regmax_t stack_pop();

extern int stack_push_silent(regmax_t _value);
extern regmax_t stack_pop_silent();

#endif