# wk8
END DATE: 12/05/2017
Well. Tasks to do: 

Implement `RRT*, FMT*`. Collect data. 

# Quickstart

## run

julia> using IJulia; notebook(detached=true, dir=".")

To run a file,
> plotly()
> include("testRRTstar.jl")
> main()

julia> include("RRT.jl"); include("algfxn.jl"); include("testRRT.jl"); main()

## Edit

> vi RRTstar.jl
> vi testRRTstar.jl 


# To run data collection

use 
`clutter_with_errorbars.jl`
and 
`walls_experiment.jl`




# Write RRT*

This is "rewiring the tree" each time we add a node, consider all neighbors and
find minimum of the total path cost through any of these neighbors.

# FMT*

Oh boy. Time for some fun algorithm writeups.
It is most similar to PRM. It needs the "total path cost" same as `RRT*`.

Section 3.4 has the implementation details. 


# Reference; Matlab Robotics Toolbox

Probably I should re-organize my code to resemble this.
<https://github.com/petercorke/robotics-toolbox-matlab/blob/master/PRM.m>

# Reference: The paper

Defines Parent and Rewire functions
<http://personalrobotics.ri.cmu.edu/files/courses/papers/Karaman11-anytimerrtstar.pdf>


# Bugs

plotting is broken for RRT
