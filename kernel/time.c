#include <synos/time.h>

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

}