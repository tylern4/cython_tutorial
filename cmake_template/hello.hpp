#include <iostream>
#ifndef __APPLE__
#include <omp.h>
#endif

extern "C" {
float hello_fortran_(int *number, float *real_number, float *total_number);
}

double hello_cpp(int number, double real_number);
