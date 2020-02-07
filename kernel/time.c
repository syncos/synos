#include <synos/time.h>
#include <synos/arch/arch.h>

time_t start;
time_t t;

static void t_update()
{

}

const time_t *ktime()
{
    t_update();
    return &t;
}
int ktime_init()
{
    arch_time_init();
    return 0;
}