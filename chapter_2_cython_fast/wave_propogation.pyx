cimport cython
from libc.math cimport M_PI as pi
from libc.math cimport sin as sin
from cython.view cimport array as cvarray

@cython.boundscheck(False)
@cython.cdivision(False)
@cython.wraparound(False)
def wave_propogation(int num_steps, int scale=100, float damping=0.25, float initial_P=250.0, int stop_step=100):
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
