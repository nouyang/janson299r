# wk8
END DATE: 11/21
Well. Tasks to do: 

Implement RRT

More PRM / RRT -> what I want to do: write up mini report, investigate
* clutter
* maze
* more dimensions woo
* error bars
bidirectional RRT? and other fun things Implement `RRT*` and `FMT*`

Read `RRT*`-> more proof magic?  Read `FMT*`



# Todo
* Error bars
* Calculate area *within* the room, as opposed to removing rectangles that fall
outside the room at all. I do the latter currently which results in a lot of
paths going through the narrow extra spaces near the walls.

# Todo
plot one of each pClutter, together on a subplot,  directly within the clutterExp() code

doublecheck yerr takes in 1 stddev or 1/2 stddev to center around the mean

!!!! Plot start and end goals, even if fail to find path...
This should DEFINITELY be done.


Check if obstacle covers start or end goals...(can a path be found at all?)

Allow obstacles to be generated outside of room (just calculate contained area)


# To run
use 
`clutter_with_errorbars.jl`
and 
`walls_experiment.jl`


# IPython Notebook

> Install Julia (I'm using version 0.6)

Add useful packages, either https://pkg.julialang.org or from a github repo.
(note: many of the "official registered" packages may be for a specific version

> Pkg.add("Plots")
> Pkg.clone("some/git/repo")


To use the Jupyter interactive browser-based "notebook"
> Pkg.add("IJulia")
> using IJulia
> notebook(dir=".")


To run a file,
> include("RRT.jl")

> cd()
> pwd()

