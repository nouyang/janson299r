using Plots
include("RRT.jl")


plot([1,2],[2,3])

cost, isPathFound, nlist = rrtPathPlanner(30)
@show isPathFound
@show cost
@show length(nlist)
#@show nlist



iterList = [60 80 100 120 150 200 300]
nTrials = 10
cost = 0
listCosts = []

print("\n\n")
for testIter in iterList 
    totalcost =0
    idx = 0
    @show testIter
    nSuccess = 0
    cost = 0
    while idx < nTrials
        cost, isPathFound, nlist = rrtPathPlanner(testIter)
        if isPathFound
            nSuccess += 1
        end
        totalcost += cost 
        idx += 1
    end
    avgCost = totalcost /  nSuccess
    @show avgCost
    @show listCosts
    print("\n\n")
    #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
    push!(listCosts, avgCost)
end

@show listCosts


