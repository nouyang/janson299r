using Plots
gr()
include("PRM.jl")
#include("RRT.jl")


plot([1,2],[2,3])

#cost, isPathFound, nlist = rrtPathPlanner(30)
#@show isPathFound
#@show cost
#@show length(nlist)
#@show nlist


iterList = [40 80 100 120 150 180 200 300]
nTrials = 30
cost = 0
listCosts = Vector{Float32}()
listpSucc= Vector{Float32}()

# 
# print("\n\n")
# for testIter in iterList 
    # totalcost =0
    # idx = 0
    # @show testIter
    # nSuccess = 0
    # cost = 0
    # while idx < nTrials
        # cost, isPathFound, nlist = rrtPathPlanner(testIter)
        # if isPathFound
            # nSuccess += 1
        # end
        # totalcost += cost 
        # idx += 1
    # end
    # avgCost = totalcost /  nSuccess
    # @show nSuccess
    # pSucc = nSuccess / nTrials
    # @show avgCost
    # @show listCosts
    # @show listpSucc
    # print("\n\n")
    # #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
    # push!(listCosts, avgCost)
    # push!(listpSucc, pSucc)
# end
# 
# @show iterList
# @show listCosts
# @show listpSucc
# 
# sizeplot = (300,300)
# 
# pRRTcost = plot(iterList, listCosts', show=true, size=sizeplot, seriestype=:scatter, 
     # legend=false, yaxis=((0,100), 0:20:100), xaxis=((0,320), 0:50:300), color=:black)
# 
# title!("RRT nIter vs pathcost")
# xlabel!("iterations requested of RRT alg")
# ylabel!("euclidean path cost")
# 
# 
# pRRTsuccess = scatter(iterList, listpSucc', legend=false, yaxis=((0,1), 0:0.1:1), xaxis=((0,320), 0:50:300), color=:orange)
# title!("RRT nIter vs pSuccess")
# ylabel!("# P(success) = numSucc / 30 trials")
# 
# plot(pRRTcost, pRRTsuccess, layout=(1,2),legend=false)
# 

#####################################

print("\n\n")
connectDist = 15
iterList = [40 80 100 120 150 180 200 300]

for testIter in iterList 
    totalcost =0
    idx = 0
    @show testIter
    nSuccess = 0
    cost = 0
    while idx < nTrials
        nodeslist, edgeslist = preprocessPRM(testIter, connectDist)
        cost, isPathFound, winPath = queryPRM(start, goal, nodeslist, edgeslist)
        if isPathFound
            nSuccess += 1
        end
        totalcost += cost 
        idx += 1
    end
    avgCost = totalcost /  nSuccess
    @show nSuccess
    pSucc = nSuccess / nTrials
    @show avgCost
    @show listCosts
    @show listpSucc
    print("\n\n")
    #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
    push!(listCosts, avgCost)
    push!(listpSucc, pSucc)
end

@show iterList
@show listCosts
@show listpSucc

sizeplot = (300,300)

pPRMcost = plot(iterList, listCosts', show=true, size=sizeplot, seriestype=:scatter, 
     legend=false, yaxis=((0,100), 0:20:100), xaxis=((0,320), 0:50:300), color=:black)

title!("RRT nIter vs pathcost")
xlabel!("iterations requested of RRT alg")
ylabel!("euclidean path cost")


pPRMsuccess = scatter(iterList, listpSucc', legend=false, yaxis=((0,1), 0:0.1:1), xaxis=((0,320), 0:50:300), color=:orange)
title!("RRT nIter vs pSuccess")
ylabel!("# P(success) = numSucc / 30 trials")

plot(pRRTcost, pRRTsuccess, layout=(1,2),legend=false)





########################################
#pRRTsuccess[:axis] 

#y = rand(100)
#lot(0:10:100,rand(11,4),lab="lines",w=3,palette=:grays,fill=0,α=0.6)
#scatter!(y,zcolor=abs(y - 0.5),m=(:heat,0.8,stroke(1,:green)),ms=10 * abs(y - 0.5) + 4,lab="grad")


#cost, isPathFound, nlist = rrtPathPlanner(40) #maxIter
#plotPath(isPathFound,nlist)


