
# 
ERROR: LoadError: MethodError: no method matching json(::Array{Any,1})
The applicable method may be too new: running in world age 24147, while current world is 24148.

https://docs.julialang.org/en/stable/manual/methods/
The implementation of this behavior is a "world age counter". This monotonically increasing value tracks each method definition operation. This allows describing "the set of method definitions visible to a given runtime environment" as a single number, or "world age"

## install GR package



# plotly() is very insistent on opening a new tab
cannot seem to surpress

just use ijulia instead? lose vim keybindings :(

## error report
**Inside file `tmp.jl`:**
> using Plots
> aPlot = scatter(show=false);
> scatter!(aPlot, [1],[2]);

Then run
> julia> include("tmp.jl")

This will always open a new tab, which is not the behavior I expect (I expect no output to show up)

If I run the same lines in the commandline, no tab opens, as I expect.

> julia> aPlot = scatter(show=false);
> julia> scatter!(aPlot, [1],[2]);

