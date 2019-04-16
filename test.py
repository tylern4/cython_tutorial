import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation
import cpp.build.wave_propogation as wave_propogation

# First set up the figure, the axis, and the plot element we want to animate
fig = plt.figure()
ax = plt.axes()

num_steps = 25000
scale = 50
stop_step = 100
damping = 0.2
initial_P = 250

pressure = wave_propogation.wave_propogation_cpp_omp(
    num_steps, scale, damping, initial_P, stop_step
)
img = ax.imshow(pressure, cmap="viridis_r", interpolation="lanczos")
plt.show()
