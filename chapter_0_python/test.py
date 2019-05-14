#!/usr/bin/env python3
import wave_propogation as wp
import time
from matplotlib import pyplot as plt


num_steps = 100
scale = 50
stop_step = 100
damping = 0.25
initial_P = 25.0


def plot_pressure(pressure):
    fig = plt.figure(figsize=(5, 5))
    ax = plt.axes()
    img = ax.imshow(pressure, cmap="viridis_r", interpolation="lanczos")
    plt.show()


start = time.time()
pressure = wp.wave_propogation(num_steps, scale, damping, initial_P, stop_step)
stop = time.time()

print(f"{stop - start:.2f} Sec, {num_steps / (stop - start):.2f} Hz")

plot_pressure(pressure)
