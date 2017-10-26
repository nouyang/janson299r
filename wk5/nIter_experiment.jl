include("PRM.jl")
pyplot()

################
# Setup

numSamples = 25
connectRadius =10 
param = algT.AlgParameters(numSamples, connectRadius)
startstate = Point(1.,1)
goalstate = Point(20.,20)

# create obstacles (fixed map for now)
obs1 = HyperRectangle(Vec(8,3.), Vec(2,2.)) #Todo
obs2 = HyperRectangle(Vec(4,4.), Vec(2,10.)) #Todo

obstacles = Vector{HyperRectangle}()
push!(obstacles, obs1, obs2)

# create room
walls = Vector{LineSegment}()
w,h  = 20,20
perimeter = HyperRectangle(Vec(0.,0), Vec(w,h))
roomPerimeter = algfxn.decompRect(perimeter)
for l in roomPerimeter
    push!(walls, l)
end

r = algT.Room(w,h,walls,obstacles)


###################
# Run iterations

nTrials = 30 #average multiple runs for the same numSamples
nTrials = 3 #average multiple runs for the same numSamples
cost = 0
listCosts = Vector{Float32}()
listpSucc= Vector{Float32}()
nSamples_list = [20 30] # number of pts to use in any given PRM run

for nSamples in nSamples_list
    totalcost = 0.
    idx = 0.
    nSuccess = 0.
    pathcost = 0.
    while idx < nTrials
        nodeslist, edgeslist = preprocessPRM(r, param)
        pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)
        if isPathFound
            nSuccess += 1
        end
        if !(pathcost == Void)
            totalcost += pathcost
        end
        idx += 1
    end

    avgCost = totalcost /  nSuccess
    pSucc = nSuccess / nTrials
    #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
    push!(listCosts, avgCost)
    push!(listpSucc, pSucc)
end

    @show listCosts
    @show listpSucc
sizeplot = (400, 600)

# sanity check
x = 1:10; y = rand(10) # These are the plotting data
plot(x,y)


pPRMcost = plot(nSamples_list, listCosts', show=true, size=sizeplot, seriestype=:scatter, 
     legend=false, yaxis=((0,100), 0:20:100), xaxis=((0,320), 0:50:300), color=:black)
successTitle = "PRM numsamples vs pathcost"
xlabel!("numsamples parameter for PRM alg")
ylabel!("euclidean path cost")


pPRMsuccess = plot(nSamples_list, listpSucc', show=true, size=sizeplot, seriestype=:scatter,
    legend=false, yaxis=((0,1), 0:0.1:1), xaxis=((0,1), 0:50:300), color=:blue)
costTitle = "PRM numsamples vs pSuccess"
ylabel!("P(success) = numSucc / $nTrials trials")
xlabel!("numsamples parameter for PRM alg")

#plot(pPRMcost, pPRMsuccess, layout=(2,1),show=true)


plot(pPRMsuccess)

