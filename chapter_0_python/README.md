## Wave Propagation example

In this example we'll look at a 2D grid describing a pressure. In the center of the grid there is a forcing function taking the pressure values to +/- initial_P. This pressure propogated away from the center as the wave spreads out in all 4 directions (up,down,left,right). For each step we will calcuate the velocity of the wave in each direction and then the new pressure at each point.


```python
for each step:
    # Calculate the pressure at the center for this stwp
    presure_at_center = initial_P * sin(omega * step)
    # Loop over rows
    for x in size_x:
        # Loop over columns
        for y in size_y
            # The velocity at each point is the difference between
            # the pressure at the point and it's neighbor in a direction
            velocity_up[x][y]    += pressure[x][y] - pressure[x - 1][y]
            velocity_down[x][y]  += pressure[x][y] - pressure[x][y + 1]
            velocity_left[x][y]  += pressure[x][y] - pressure[x + 1][y]
            velocity_right[x][y] += pressure[x][y] - pressure[x][y - 1]
    # Now we recalculate the pressure for each point
    # based on how pressure was lost to the velocities
    for x in size_x:
        for y in size_y
            pressure[x][y] -= sum(velocities)
```
