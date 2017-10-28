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


## PARAMETERS
connectRadius = 8
targetNumObs = 5
clutterPercentage = 0.2
roomWidth,roomHeight  = 20,20

startstate = Point(1.,1)
goalstate = Point(20.,20)



## INIT
obstacles = Vector{HyperRectangle}()
perimeter = HyperRectangle(Vec(0.,0), Vec(roomWidth,roomHeight))
wallsPerimeter = algfxn.decompRect(perimeter)

walls = Vector{LineSegment}()
for l in wallsPerimeter
    push!(walls, l)
end


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


### Run PRM on cluttered room

r = algT.Room(roomWidth,roomHeight,walls,obstacles)
plotfxn.plotRoom(r)

## Run preprocessing
numSamples = 25
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
