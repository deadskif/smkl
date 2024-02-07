#include <stdio.h>
#include "subbin.h"
#ifndef SUBBIN
# error Define SUBBIN
#endif
int main(int argc, const char *argv[])
{
    printf("SUBBIN_DEFINE = %d\n", SUBBIN_DEFINE);
    return 0;
}
