import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation
import cpp.build.wave_propogation as wave_propogation

import matplotlib.style
import matplotlib as mpl

mpl.style.use("dark_background")

# First set up the figure, the axis, and the plot element we want to animate
fig = plt.figure(figsize=(5, 5))
ax = plt.axes()

num_steps = 10
scale = 50
stop_step = 100
damping = 0.2
initial_P = 250

pressure = wave_propogation.wave_propogation_cpp_omp(
    num_steps, scale, damping, initial_P, stop_step
)
img = ax.imshow(pressure, cmap="viridis_r", interpolation="lanczos")

# initialization function: plot the background of each frame
def init():
    img.set_data(pressure)
    return [img]


# animation function.  This is called sequentially
def animate(i):
    p = wave_propogation.wave_propogation_cpp_omp(
        i, scale, damping, initial_P, stop_step
    )
    img.set_data(p)
    return [img]


# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(
    fig, animate, init_func=init, frames=500, interval=1, blit=False
)

# save the animation as an mp4.  This requires ffmpeg or mencoder to be
# installed.  The extra_args ensure that the x264 codec is used, so that
# the video can be embedded in html5.  You may need to adjust this for
# your system: for more information, see
# http://matplotlib.sourceforge.net/api/animation_api.html
anim.save("wave.mp4", fps=30, extra_args=["-vcodec", "libx264"], dpi=100)

# plt.show()
