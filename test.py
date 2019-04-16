import numpy as np
import cpp.build.wave_propogation as wave_propogation
from numpy.core.umath import pi
from numpy.ma import sin
import time


def wave_propogation_py(
    num_steps, scale=100, damping=0.25, initial_P=250, stop_step=100
):
    omega = 3 / (2 * pi)

    size_x = 2 * scale + 1
    size_y = 2 * scale + 1
    vertPos = int(scale)
    horizPos = int(scale)

    # V velocity
    # P presure
    # Initialization
    P = [[0.0 for x in range(size_x)] for y in range(size_y)]
    V = [[[0.0, 0.0, 0.0, 0.0] for x in range(size_x)] for y in range(size_y)]
    P[vertPos][horizPos] = initial_P
    start = time.time()
    for step in range(num_steps):
        if step <= stop_step:
            P[vertPos][horizPos] = initial_P * sin(omega * step)
        for i in range(size_y):
            for j in range(size_x):
                V[i][j][0] = V[i][j][0] + P[i][j] - P[i - 1][j] if i > 0 else P[i][j]
                V[i][j][1] = (
                    V[i][j][1] + P[i][j] - P[i][j + 1] if j < size_x - 1 else P[i][j]
                )
                V[i][j][2] = (
                    V[i][j][2] + P[i][j] - P[i + 1][j] if i < size_y - 1 else P[i][j]
                )
                V[i][j][3] = V[i][j][3] + P[i][j] - P[i][j - 1] if j > 0 else P[i][j]

        for i in range(size_y):
            for j in range(size_x):
                P[i][j] -= 0.5 * damping * sum(V[i][j])

    end = time.time()
    print(f"{end-start} S ===> {num_steps/(end-start)} Hz")
    return P


num_steps = 2500
scale = 50
stop_step = 100
damping = 0.2
initial_P = 250


for n in range(500, num_steps, 500):
    print(n)
    pressure_0 = wave_propogation_py(n, scale, damping, initial_P, stop_step)
    print(np.array_equal(pressure_0, pressure_0))
    pressure = wave_propogation.wave_propogation(
        n, scale, damping, initial_P, stop_step
    )
    print(np.array_equal(pressure_0, pressure))
    pressure = wave_propogation.wave_propogation_cy_fast(
        n, scale, damping, initial_P, stop_step
    )
    print(np.array_equal(pressure_0, pressure))
    pressure = wave_propogation.wave_propogation_cpp(
        n, scale, damping, initial_P, stop_step
    )
    print(np.array_equal(pressure_0, pressure))
    pressure = wave_propogation.wave_propogation_cpp_omp(
        n, scale, damping, initial_P, stop_step
    )
    print(np.array_equal(pressure_0, pressure))
