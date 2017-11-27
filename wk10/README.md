# wk8
END DATE: 11/28/2017
Well. Tasks to do: 

Implement `RRT*, PRM*, and FMT*`

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

julia> using IJulia; notebook(detached=true, dir=".")



To run a file,
> include("RRT.jl")

> cd()
> pwd()


# 

Pkg.update(); ENV["GRDIR"] = ""; Pkg.build("GR")
. BTW: MWE is an abbreviation for "minimal working example" (to reproduce the problem).


```
https://en.wikibooks.org/wiki/Introducing_Julia/Working_with_dates_and_times#Date_formatting

```

Font attribute does not seem to impact jupyter rendering of plotly graphs, although you can at least change the actual font.
But I can't get "bold" to show up. ("Courier Bold" does not work).
