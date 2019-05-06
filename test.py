import numpy as np
import cpp.build.wave_propogation as wave_propogation
from numpy.core.umath import pi
from numpy.ma import sin
import time
from matplotlib import pyplot as plt
import pandas as pd


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
    return P


num_steps = 10000
scale = 50
stop_step = 100
damping = 0.2
initial_P = 250


def plots(p, type, number):
    fig = plt.figure(figsize=(5, 5))
    ax = plt.axes()
    img = ax.imshow(p, cmap="viridis_r", interpolation="lanczos")
    plt.savefig(f"outputs/{type}_{number}.png")


funcs = {
    "Python": wave_propogation_py,
    "Cython": wave_propogation.wave_propogation,
    "Cython_fast": wave_propogation.wave_propogation_cy_fast,
    "Cpp": wave_propogation.wave_propogation_cpp,
    "Omp": wave_propogation.wave_propogation_cpp_omp,
    "Fortran": wave_propogation.wave_propogation_fortran,
}

with open("results.csv", "w") as file:
    file.write("type,num,start,stop,elapsed\n")
    for n in range(100, num_steps, 10):
        for name, func in funcs.items():
            start = time.time()
            pressure = func(n, scale, damping, initial_P, stop_step)
            stop = time.time()
            file.write(
                name
                + ","
                + str(n)
                + ","
                + str(start)
                + ","
                + str(stop)
                + ","
                + str(stop - start)
                + "\n"
            )
            print(name, n, n / (stop - start))
            # plots(pressure, name, n)
