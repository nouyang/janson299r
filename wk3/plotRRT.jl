using Plots
gr()
include("RRT.jl")
closeall()



cost, isPathFound, nlist = rrtPathPlanner(30)
@show isPathFound
@show cost
@show length(nlist)
@show nlist


iterList = [40 80 100 120 150 180 200 300]
nTrials = 30
cost = 0
listCosts = Vector{Float32}()
listpSucc= Vector{Float32}()

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

sizeplot = (400, 600)


# plot nIter vs pathcost 
 pRRTcost = plot(iterList, listCosts', show=true, size=sizeplot, seriestype=:scatter, 
      legend=false, yaxis=((0,100), 0:20:100), xaxis=((0,320), 0:50:300), color=:black)

title!("RRT nIter vs pathcost")
ylabel!("euclidean path cost")

# plot nIter vs success rate
pRRTsuccess = scatter(iterList, listpSucc', legend=false, size=sizeplot, yaxis=((0,1), 0:0.1:1), xaxis=((0,320), 0:50:300), color=:orange)
title!("RRT nIter vs pSuccess")
ylabel!("# P(success) = numSucc / 30 trials")
xlabel!("iterations requested of RRT alg")

plot(pRRTcost, pRRTsuccess, layout=(2,1),legend=false)


 


# [slack] <mkborregaard> twinx
# [slack] <mkborregaard> plot(something); plot!(twinx(), something)



########################################
### DO NOT USE (why is this here?)
#pRRTsuccess[:axis] 
 
# y = rand(100)
# plot(0:10:100,rand(11,4),lab="lines",w=3,palette=:grays,fill=0,α=0.6)
# scatter!(y,zcolor=abs(y - 0.5),m=(:heat,0.8,stroke(1,:green)),ms=10 * abs(y - 0.5) + 4,lab="grad")
 # 
 # 
# cost, isPathFound, nlist = rrtPathPlanner(40) #maxIter
# plotPath(isPathFound,nlist)
 # 
# 
