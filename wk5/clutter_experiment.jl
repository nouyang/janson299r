include("PRM.jl")
#using Distributions

gr()

connectRadius = 8

startstate = Point(1.,1)
goalstate = Point(20.,20)

# create obstacles (fixed map for now)
#obs1 = HyperRectangle(Vec(8,3.), Vec(2,2.)) #Todo
#obs2 = HyperRectangle(Vec(4,4.), Vec(2,10.)) #Todo

obstacles = Vector{HyperRectangle}()
#push!(obstacles, obs1, obs2)

# create room
roomWidth,roomHeight  = 20,20
perimeter = HyperRectangle(Vec(0.,0), Vec(roomWidth,roomHeight))
wallsPerimeter = algfxn.decompRect(perimeter)

walls = Vector{LineSegment}()
for l in wallsPerimeter
    push!(walls, l)
end


# implement function to create clutter
# Let's say on average we want to create 4 obstacles... (otherwise, *most* of
# the time we will product one large rectangle that is falling out of the room

targetNumObs = 2 

clutterPercentage = 0.1
roomArea = roomWidth * roomHeight

targetSumObsArea= roomArea * clutterPercentage
sumObsArea = 0


while sumObsArea < targetSumObsArea
    x,y = rand(Uniform(1, roomWidth),2)
    randWidth, randHeight = rand(Uniform(1, roomWidth/targetNumObs),2)
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


### Run PRM on cluttered room

r = algT.Room(roomWidth,roomHeight,walls,obstacles)
plotfxn.plotRoom(r)

## Run preprocessing
numSamples =10 
connectRadius =10 
param = algT.AlgParameters(numSamples, connectRadius)
nodeslist, edgeslist = preprocessPRM(r, param)
print("\n ---- pre-processed --- \n")

## Query created RM
startstate = Point(1.,1)
goalstate = Point(18.,18)

pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)
print("\n ---- queried ---- \n")

## Plot path found
timestamp = Base.Dates.now()
title = "PRM with # samples=$numSamples, maxDist=$connectRadius, \npathcost = $pathcost, 
        timestamp=$timestamp)\n\n"
roadmap = algT.roadmap(startstate, goalstate, nodeslist, edgeslist)


plot = plotfxn.plotPRM(roadmap, solPath, title::String)
gui()

print("\n --- Time --- \n")
@show timestamp
print("\n --- Obstacles --- \n")
@show obstacles 
print("\n --- Nodes --- \n")
@show nodeslist 
print("\n --- Edges --- \n")
@show edgeslist 
print("\n -------- \n")


# todo: save one "representative" figure from each run
