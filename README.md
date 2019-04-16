# Tutorial on using Cython

This basic tutorial will show how to do a simple iterative wave propagation in python and then speed it us using cython and C++ and OpenMP.

![Wave Propagation Gif](wave.gif)

## Algorithm
The basic algorithm takes the pressure in one cell of the matrix and then calculates the velocity in the four adjacent cells (up,down,left,right) based on the pressure difference in those four cells. After the velocities are calculated the pressure at the points is re-calculated knowing that some of the pressure has moved by the velocity. The pressure at the center oscillates with a sinusoidal frequency for some number of steps.

```
for each step:
  presure_at_center = initial_P * sin(omega * step)
  for x in size_x:
    for y in size_y
      velocity_u[x][y] += pressure[x][y] - pressure[x - 1][y]
      velocity_d[x][y] += pressure[x][y] - pressure[x][y + 1]
      velocity_l[x][y] += pressure[x][y] - pressure[x + 1][y]
      velocity_r[x][y] += pressure[x][y] - pressure[x][y - 1]
    for x in size_x:
      for y in size_y
        pressure[x][y] -= sum(velocities)
```

## Credits
Basic wave propagation algorithm found in https://github.com/Alexander3/wave-propagation.
