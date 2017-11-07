using Plots
include("PRM.jl")
#using Distributions

gr()


#### HELPER FXN 

    function areaRect(r::HyperRectangle)
        w, h = widths(r)
        area = w*h
    end

    function unionAreaRects(r1::HyperRectangle, r2::HyperRectangle)
        area1 = areaRect(r1)
        area2 = areaRect(r2)
        overlap = areaRect(intersect(r1, r2))
        area = area1 + area2 - overlap
        return area
    end
### END 


#################################### 
## PARAMETERS
#################################### 
numSamples = 40
connectRadius = 2 
param = algT.AlgParameters(numSamples, connectRadius)

targetNumObs = 3
clutterPercentage = 0.15
roomWidth,roomHeight  = 20,20

startstate = Point(4.,4)
goalstate = Point(15.,15)

#################################### 
## INIT
#################################### 
obstacles = Vector{HyperRectangle}()
perimeter = HyperRectangle(Vec(0.,0), Vec(roomWidth,roomHeight))
wallsPerimeter = algfxn.decompRect(perimeter)

walls = Vector{LineSegment}()
for l in wallsPerimeter
    push!(walls, l)
end


#################################### 
# Randomly Generate Clutter (obstacles) 
####################################

# implement function to create clutter
# Let's say on average we want to create 4 obstacles... (otherwise, *most* of
# the time we will product one large rectangle that is falling out of the room

#targetNumObs = 2 

roomArea = roomWidth * roomHeight
targetSumObsArea= roomArea * clutterPercentage
sumObsArea = 0

while sumObsArea < targetSumObsArea
    #x,y = rand(Uniform(1, roomWidth),2)
    x,y = rand(1.0:roomWidth,2)

    randWidth, randHeight = rand(Uniform(1, roomWidth/targetNumObs),2)
    #randWidth, randHeight = rand(1:roomWidth/targetNumObs,2)
    protoObstacle = HyperRectangle(Vec(x, y), Vec(randWidth, randHeight)) #Todo
    if contains(perimeter, protoObstacle)
        push!(obstacles, protoObstacle)
        sumObsArea += randWidth*randHeight
    end
end
print("obstacles generated")


#plot!(walls, color =:black)
#plot!(obstacles, fillalpha=0.5)


@show targetSumObsArea
@show sumObsArea


#################################### 
# Run PRM once and display config space plot  
####################################


r = algT.Room(roomWidth,roomHeight,walls,obstacles)
plotfxn.plotRoom(r)

## Run preprocessing
nodeslist, edgeslist = preprocessPRM(r, param)
print("\n ---- pre-processed --- \n")

## Query created RM

pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)
print("\n ---- queried ---- \n")

## Plot path found
timestamp = Base.Dates.now()
title = "PRM with # samples=$numSamples, maxDist=$connectRadius, \npathcost = $pathcost, 
        timestamp=$timestamp)\n\n"
roadmap = algT.roadmap(startstate, goalstate, nodeslist, edgeslist)


plotfxn.plotPRM(roadmap, solPath, title::String)
gui()

print("\n --- Time --- \n")
@show timestamp
#print("\n --- Obstacles --- \n")
#@show obstacles 
#print("\n --- Nodes --- \n")
#@show nodeslist 
#print("\n --- Edges --- \n")
#@show edgeslist 
print("\n -------- \n")


# todo: save one "representative" figure from each run

#################################### 
# Run multiple trials and scatterplot all cost vs area for all runs 
# due to varying absolute area
####################################

####################################
## Parrameters
####################################
nTrials = 30
nSamples_list = [10 20 30 80 150 200 300]

####################################
## Init
####################################
cost = 0
listCosts = Vector{Float32}()
listpSucc= Vector{Float32}()

####################################
# Run Trials
####################################

#@show listpSucc

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
print("Time to run experiment: $timeExperiment\n")
timestamp = Base.Dates.now()



####################################
# Plot Results
####################################
# clutter (area) on X
# pathcost on Y
sizeplot = (800, 800)

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



