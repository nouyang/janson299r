include("PRM.jl")
pyplot()

################
# Setup

connectRadius = 10 

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
nSamples_list = [20, 30] # number of pts to use in any given PRM run
#iterList = [20 30 ]
iterList = [20 30 50 100 150 200 300]

tic()
for nSamples in nSamples_list
    totalcost = 0.
    idx = 0.
    nSuccess = 0.
    pathcost = 0.
    param = algT.AlgParameters(nSamples, connectRadius)
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


blah = toc()
print("Time to: $blah")


@show listCosts
@show listpSucc
sizeplot = (400, 800)

plot() 
# sanity check

costTitle= "PRM numsamples vs pathcost"
maxX = nSamples_list[end] #apparently, cannot use variables in xaxis declaration :(

pPRMcost = scatter(nSamples_list, listCosts, size=sizeplot, 
    color=:black,
    title = costTitle, ylabel = "euclidean path cost", xlabel = "numsamples parameter for PRM alg",
    xaxis=((0, 300), 0:50:300),
    yaxis=((0,100), 0:20:100))

successTitle = "PRM numsamples vs pSuccess"
pPRMsuccess = scatter(nSamples_list, listpSucc,
    #legend=false, yaxis=((0,1.1), 0:0.1:1), xaxis=((0,maxX+20), 0:50:maxX), color = :orange, markersize= 6)
    color = :orange, markersize= 6, 
    ylabel = ("P(success) = numSucc / $nTrials trials"), xlabel = "numsamples parameter for PRM alg",
    xaxis=((0, 300), 0:50:300),
    yaxis=((0,1), 0:0.1:1), 
    title = successTitle)

plot(pPRMcost, pPRMsuccess, layout=(2,1), title="PRM with connection radius = $connectRadius", 
     #legend=false, xaxis=((0, maxX+50), 0:50:maxX))
    )




