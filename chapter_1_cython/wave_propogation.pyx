cimport cython
from libc.math cimport M_PI as pi
from libc.math cimport sin as sin
from cython.view cimport array as cvarray

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
