include("PRM.jl")
pyplot()

################
# Setup

connectRadius = 5

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
cost = 0
listCosts = Vector{Float32}()
listpSucc= Vector{Float32}()
nSamples_list = [10 20 30 80 150 200 300]

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


timeExperiment = toc();
print("Time to: $timeExperiment\n")
timestamp = Base.Dates.now()


@show listCosts
@show listpSucc
sizeplot = (800, 800)

# sanity check
plot()


supTitle="\nPRM with maxDist=$connectRadius, nTrials=$nTrials.
        (time to run:$timeExperiment, timestamp=$timestamp)\n\n"
costTitle= "numsamples vs pathcost\n"

pPRMcost = scatter(nSamples_list, listCosts',
    color=:black,
    title = supTitle * costTitle, ylabel = "euclidean path cost", xlabel = "numsamples",
    yaxis=((0,100), 0:20:100))

successTitle = "\nnumsamples vs pSuccess\n"
pPRMsuccess = scatter(nSamples_list, listpSucc',
    color = :orange, markersize= 6, 
    title = successTitle, ylabel = ("P(success)=numSucc/$nTrials trials"), xlabel = "numsamples",
    yaxis=((0, 1.2), 0:0.1:1))

plot(pPRMcost, pPRMsuccess, layout=(2,1), legend=false,
    xaxis=((0, 320), 0:50:300),
    size = sizeplot)


# todo: save one "representative" figure from each run , to plot
# todo: truncate timestamp and elapsed time, so that it doesn't give silly amounts of precision
