using Plots
include("RRT.jl")


plot([1,2],[2,3])

cost, isPathFound, nlist = rrtPathPlanner(30)
@show isPathFound
@show cost
@show length(nlist)
#3@show nlist
