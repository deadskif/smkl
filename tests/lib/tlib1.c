#include <stdio.h>
#include <zlib.h>
#include "tlib.h"
#include "tlib_inner.h"

int tlib_func1(int a, int b) {
    printf("WTF %s\n", zlibVersion());
    return a + b * TLIB_A;
}
