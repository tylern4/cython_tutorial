#include <chrono>
#include <iostream>
#include <math.h>
#include <omp.h>

void wave_propogation_single(int num_steps, int scale, float damping,
                             float initial_P, float *_P);

void wave_propogation_omp(int num_steps, int scale, float damping,
                          float initial_P, float *_P);
