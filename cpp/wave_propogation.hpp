#include <chrono>
#include <iostream>
#include <math.h>
#ifndef __APPLE__
#include <omp.h>
#endif

extern "C" {
void wave_propogation_fortran_(int *num_steps, int *scale, float *damping,
                               float *initial_P, int *stop_step, float *_P);
}

void wave_propogation_single(int num_steps, int scale, float damping,
                             float initial_P, int stop_step, float *_P);

void wave_propogation_omp(int num_steps, int scale, float damping,
                          float initial_P, int stop_step, float *_P);
