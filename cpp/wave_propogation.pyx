from libc.stdlib cimport malloc, free
from cpython.mem cimport PyMem_Malloc
import numpy as np
import time
cimport cython
from cython.view cimport array as cvarray

cdef extern from "wave_propogation.hpp":
  void wave_propogation_single(int, int, float, float, int, float*)
  void wave_propogation_omp(int, int, float, float, int, float*)
  void wave_propogation_fortran_(int*, int*, float*, float*, int*, float*)


@cython.boundscheck(False)
@cython.cdivision(True)
@cython.wraparound(False)
@cython.infer_types(False)
def wave_propogation_fortran(int num_steps, int scale=100,float damping=0.25, float initial_P=250.0, int stop_step=100):
  cdef int size_x = 2 * scale + 1
  cdef int size_y = 2 * scale + 1
  cdef int *_num_steps=&num_steps
  cdef int *_scale=&scale
  cdef float *_damping=&damping
  cdef float *_initial_P=&initial_P
  cdef int *_stop_step=&stop_step

  cdef float *array = <float *> malloc(sizeof(float) * size_x * size_y)
  wave_propogation_fortran_(_num_steps, _scale, _damping, _initial_P, _stop_step, array)
  P = [[0.0 for x in range(size_x)] for y in range(size_y)]
  for i in range(size_x):
    for j in range(size_y):
      P[i][j] = array[i*size_x+j] if not np.isnan(array[i*size_x+j]) else 0.0
  return P

@cython.boundscheck(False)
@cython.cdivision(True)
@cython.wraparound(False)
@cython.infer_types(False)
def wave_propogation_cpp(int num_steps, int scale=100,float damping=0.25, float initial_P=250.0, int stop_step=100):
  cdef int size_x = 2 * scale + 1
  cdef int size_y = 2 * scale + 1
  cdef float *array = <float *> malloc(sizeof(float) * size_x * size_y)
  wave_propogation_single(num_steps, scale, damping, initial_P, stop_step, array)
  P = [[0.0 for x in range(size_x)] for y in range(size_y)]
  for i in range(size_x):
    for j in range(size_y):
      P[i][j] = array[i*size_x+j] if not np.isnan(array[i*size_x+j]) else 0.0
  return P

@cython.boundscheck(False)
@cython.cdivision(True)
@cython.wraparound(False)
@cython.infer_types(False)
def wave_propogation_cpp_omp(int num_steps, int scale=100, float damping=0.25, float initial_P=250.0, int stop_step=100):
  cdef int size_x = 2 * scale + 1
  cdef int size_y = 2 * scale + 1
  cdef int i = 0
  cdef int j = 0
  cdef float *array = <float *> malloc(sizeof(float) * size_x * size_y)
  wave_propogation_omp(num_steps, scale, damping, initial_P, stop_step, array)
  P = [[0.0 for x in range(size_x)] for y in range(size_y)]
  for i in range(size_x):
    for j in range(size_y):
      P[i][j] = array[i*size_x+j] if not np.isnan(array[i*size_x+j]) else 0.0
  return P

def wave_propogation(num_steps, scale=100, damping=0.25, initial_P=250.0, stop_step=100):
    omega = 3.0 / (2.0 * pi)

    size_x = 2 * scale + 1
    size_y = 2 * scale + 1
    vertPos = scale
    horizPos = scale
    max_pressure = initial_P / 2.0
    min_presure = -initial_P / 2.0

    # V velocity
    # P presure
    # Initialization
    P = [[0.0 for x in range(size_x)] for y in range(size_y)]
    V = [[[0.0, 0.0, 0.0, 0.0] for x in range(size_x)] for y in range(size_y)]

    P[vertPos][horizPos] = initial_P

    for step in range(num_steps):
      if(step <= stop_step):
        P[vertPos][horizPos] = initial_P * sin(omega * step)
      for i in range(size_x):
        for j in range(size_y):
          V[i][j][0] = V[i][j][0] + P[i][j] - P[i - 1][j] if i > 0 else P[i][j]
          V[i][j][1] = V[i][j][1] + P[i][j] - P[i][j + 1] if j < size_x - 1 else P[i][j]
          V[i][j][2] = V[i][j][2] + P[i][j] - P[i + 1][j] if i < size_y - 1 else P[i][j]
          V[i][j][3] = V[i][j][3] + P[i][j] - P[i][j - 1] if j > 0 else P[i][j]

      for i in range(size_y):
        for j in range(size_y):
          P[i][j] -= 0.5 * damping * sum(V[i][j])
    return P

from libc.math cimport M_PI as pi
from libc.math cimport sin as sin
@cython.boundscheck(False)
@cython.cdivision(False)
@cython.wraparound(False)
def wave_propogation_cy_fast(int num_steps, int scale=100, float damping=0.25, float initial_P=250.0, int stop_step=100):
    cdef float omega = 3.0 / (2.0 * pi)

    cdef int size_x = 2 * scale + 1
    cdef int size_y = 2 * scale + 1
    cdef int vertPos = scale
    cdef int horizPos = scale
    cdef float max_pressure = initial_P / 2.0
    cdef float min_presure = -initial_P / 2.0

    cdef int i = 0
    cdef int j = 0
    cdef int step = 0

    # V velocity
    # P presure
    # Initialization

    cdef float [:,:] P = cvarray(shape=(size_x, size_y), itemsize=sizeof(float), format="f")
    P[:,:] = 0.0
    cdef float [:,:,:] V = cvarray(shape=(size_x, size_y, 4), itemsize=sizeof(float), format="f")
    V[:,:,:] = 0.0

    P[vertPos][horizPos] = initial_P

    for step in range(num_steps):
      if(step <= stop_step):
        P[vertPos][horizPos] = initial_P * sin(omega * step)
      for i in range(size_x):
        for j in range(size_y):
          V[i][j][0] = V[i][j][0] + P[i][j] - P[i - 1][j] if i > 0 else P[i][j]
          V[i][j][1] = V[i][j][1] + P[i][j] - P[i][j + 1] if j < size_x - 1 else P[i][j]
          V[i][j][2] = V[i][j][2] + P[i][j] - P[i + 1][j] if i < size_y - 1 else P[i][j]
          V[i][j][3] = V[i][j][3] + P[i][j] - P[i][j - 1] if j > 0 else P[i][j]

      for i in range(size_y):
        for j in range(size_y):
          P[i][j] -= 0.5 * damping * (V[i][j][0]+V[i][j][1]+V[i][j][2]+V[i][j][3])
    return P
