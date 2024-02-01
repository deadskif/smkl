#include <stdio.h>
#include <math.h>
#include "tlib.h"
#include "tslib_inner.h"

int main(int argc, const char *argv[])
{
    printf("tlib_func0(1,2) = %i\n", tlib_func0(1,2));
    printf("tslib_func0(1,2) = %i\n", tslib_func0(1));
    printf("sin(1) = %f\n", sin(1));
    return 0;
}
