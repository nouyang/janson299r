This is a "dirty code" repository for my work on my 299r (semeseter-long rotation) with Prof. Lucas Janson (Fall 2017).


## To run

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


## Useful links

* http://juliaplots.github.io/
* http://docs.julialang.org/
* https://github.com/tkoolen/RoboticsJuliaCon2017.jl/tree/master/notebook
* https://github.com/rdeits/agileroboticstutorial.jl

### Commands

> cd("/home/nrw/projects/julia/AgileRoboticsTutorial.jl/")
> pwd()



### Neat Things

Animated Gifs
https://github.com/rdeits/AgileRoboticsTutorial.jl/blob/master/notebooks/6.%20Optimization%20with%20JuMP.ipynb

