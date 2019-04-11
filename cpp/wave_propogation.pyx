from libc.stdlib cimport malloc, free
from cpython.mem cimport PyMem_Malloc
import numpy as np
cimport cython

cdef extern from "wave_propogation.hpp":
  void wave_propogation_single(int, int,float, float, float*)
  void wave_propogation_omp(int, int,float, float, float*)

@cython.boundscheck(False)
@cython.cdivision(True)
@cython.wraparound(False)
@cython.infer_types(False)
def wave_propogation_cpp(num_steps, scale, damping, initial_P):
  cdef int size_x = 2 * scale + 1
  cdef int size_y = 2 * scale + 1
  cdef float *array = <float *> malloc(sizeof(float) * size_x * size_y)
  wave_propogation_single(num_steps, scale, damping, initial_P, array)
  P = [[0.0 for x in range(size_x)] for y in range(size_y)]
  for i in range(size_x):
    for j in range(size_y):
      P[i][j] = array[i*size_x+j] if not np.isnan(array[i*size_x+j]) else 0.0
  return P

@cython.boundscheck(False)
@cython.cdivision(True)
@cython.wraparound(False)
@cython.infer_types(False)
def wave_propogation_cpp_omp(num_steps, scale, damping, initial_P):
  cdef int size_x = 2 * scale + 1
  cdef int size_y = 2 * scale + 1
  cdef int i = 0
  cdef int j = 0
  cdef float *array = <float *> malloc(sizeof(float) * size_x * size_y)
  wave_propogation_omp(num_steps, scale, damping, initial_P, array)
  P = [[0.0 for x in range(size_x)] for y in range(size_y)]
  for i in range(size_x):
    for j in range(size_y):
      P[i][j] = array[i*size_x+j] if not np.isnan(array[i*size_x+j]) else 0.0
  return P
