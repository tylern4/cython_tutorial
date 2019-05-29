from libc.stdlib cimport malloc, free
from cpython.mem cimport PyMem_Malloc
import numpy as np
import time
cimport cython
from cython.view cimport array as cvarray

cdef extern from "hello.hpp":
  float hello_fortran_(int*, float*, float*)
  double hello_cpp(int, double)


def hello_from_cpp(int number, double real_number):
  return hello_cpp(number, real_number)

def hello_from_fortran(int number, float real_number):
  cdef int *_number = &number
  cdef float *_real_number = &real_number

  cdef float total_number = 0
  cdef float *_total_number = &total_number
  total_number = hello_fortran_(_number,_real_number,_total_number)
  return total_number
