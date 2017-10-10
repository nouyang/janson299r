using Plots
gr()
include("PRM.jl")


plot([1,2],[2,3])

start = rrt.Point(0,0)
goal = rrt.Point(18,18)


obstacleList = Vector{rrt.Obstacle}()
obs1 = rrt.Obstacle(rrt.Point(8,3),rrt.Point(10,18)) #Todo
push!(obstacleList,obs1)
obs2 = rrt.Obstacle(rrt.Point(15,13),rrt.Point(17,15)) #Todo
push!(rrt.obstacleList,obs2)




#iterList = [40 80 100 120 150 180 200 300]
nTrials = 30
cost = 0
listCosts = Vector{Float32}()
listpSucc= Vector{Float32}()

print("\n\n")
connectDist = 10
iterList = [20 30 50 100 150 200 300]

for testIter in iterList 
    totalcost =0
    idx = 0
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
    pSucc = nSuccess / nTrials
    #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
    push!(listCosts, avgCost)
    push!(listpSucc, pSucc)
    @show listCosts

end


sizeplot = (400, 600)
pPRMcost = plot(iterList, listCosts', show=true, size=sizeplot, seriestype=:scatter, 
     legend=false, yaxis=((0,100), 0:20:100), xaxis=((0,320), 0:50:300), color=:black)

title!("PRM nIter vs pathcost")
xlabel!("iterations requested of PRM alg")
ylabel!("euclidean path cost")


pPRMsuccess = scatter(iterList, listpSucc', size=sizeplot, legend=false, yaxis=((0,1), 0:0.1:1), xaxis=((0,320), 0:50:300), color=:orange)
title!("RRM nIter vs pSuccess")
ylabel!("# P(success) = numSucc / 30 trials")

plot(pPRMcost, pPRMsuccess, layout=(2,1),legend=false)


############################
############################

obstacleList = Vector{rrt.Obstacle}()
obs1 = rrt.Obstacle(rrt.Point(8,3),rrt.Point(10,18)) #Todo
push!(obs1)



obs2 = rrt.Obstacle(rrt.Point(15,13),rrt.Point(17,15)) #Todo
push!(obs2)
