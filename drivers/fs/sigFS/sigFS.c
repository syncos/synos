#include <mkos/log.h>
#include <mkos/drivers/module.h>
#include <mkos/drivers/fs.h>

struct Module sigFS_module;
struct Filesystem sigFS_fs;

int sigFS_init(int argc, char** argv)
{
    sigFS_module.name = "sigFS";
    sigFS_module.description = "sigFS is a filesystem specifically designed for mkos. It is designed to be simple, fast, and reliable.";
    sigFS_module.author = "64epicks";
    sigFS_module.licence = "MIT";

    sigFS_module.type = FILESYSTEM;
    sigFS_module.version = 0;
    sigFS_module.version_minor = 1;

    pr_log(INFO, "SigFS module loaded!");
}
int sigFS_deInit()
{

}

Module_Init(sigFS_init);
Module_DeInit(sigFS_deInit);
Module_Info(sigFS_module);