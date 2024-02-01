#include "tlib.h"
#include "tlib_inner.h"

int tlib_func0(int a, int b) {
    return a + b * TLIB_A + tlib_func1(a, b);
}
