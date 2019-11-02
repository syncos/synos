#ifndef DRIVERS_MODULE_H
#define DRIVERS_MODULE_H

enum Module_Type
{
    FILESYSTEM,
    PMS
};

struct Module
{
    const char* name;
    const char* description;
    const char* author;
    const char* licence;
    
    int version;
    int version_minor;
    enum Module_Type type;
    void* type_struct;
};

#define Module_Init(function) int (*moduleInit)(int, char**) = function
#define Module_DeInit(function) int (*moduleDeInit)() = function
#define Module_Info(module) struct Module* Module_Info = &module

#endif