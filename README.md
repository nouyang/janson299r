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


## Timeline

* 9/14: read RRT and PRM initial papers, confirmed this is happening
* 9/21: have RRT and PRM implemented in code with some simulation results
* 9/28: have more comprehensive simulation results and have read probabilistic completeness papers for RRT and PRM
* 10/5: talk more about probabilistic completeness and any exercises from previous week
* 10/12: discuss RRT* and its algorithms and mathematical results
* 10/19: dedicating entire week to fellowship applications
* 10/26: discuss RRT* paper more and just have read FMT* paper
* 11/2: have implementations of RRT*, PRM* and FMT*
* 11/9: go over some simulation results, discuss idea for improving algorithms
* 11/16: go through improved algorithm simulations, maybe produce videos
* 11/23: surprise!
* 11/30: outline / very rough draft due
* 12/7: rough draft or report due
* 12/14: Final report due and we'll talk about it
