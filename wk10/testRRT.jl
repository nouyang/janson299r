####################################################

#  testRRT.jl

#  This file is used for development and testing of RRT.jl
#  nouyang 2017

####################################################
# MAIN
####################################################
include("RRT.jl")
plotly()


function main()
#  runs the PRM once and plots the results.
    startstate = Point(0.,0)
    goalstate = Point(20.,20)

    numSamples = 200
    connectRadius = 10
	flagOptimal = false
    param = algT.AlgParameters(numSamples, connectRadius)

    print("\n ---- Running PRM ------\n")
    ## Define obstacles
    obs1 = HyperRectangle(Vec(8,3.), Vec(2,2.)) #Todo
    obs2 = HyperRectangle(Vec(4,4.), Vec(2,10.)) #Todo
    obs3 = HyperRectangle(Vec(14,14.), Vec(3,4.)) #Todo

    obstacles = Vector{HyperRectangle}()
    push!(obstacles, obs1, obs2, obs3)

    # Define walls
    walls = Vector{LineSegment}()
    w,h  = 20,20
    perimeter = HyperRectangle(Vec(0.,0), Vec(w,h))
    roomPerimeter = algfxn.decompRect(perimeter)
    #internalwalls =  (linesegs
    for l in roomPerimeter
        push!(walls, l)
    end

    r = algT.Room(w,h,walls,obstacles)
    roomPlot = plotfxn.plotRoom(r)

    #!
    nodeslist, edgeslist, isPathFound, pathNodes, pathcost = rrtPlan(r, param, startstate, goalstate, obstacles)

    ## Plot path found
    #title = "PRM with # samples =$numSamples, \nPathfound = $isPathFound, \npathcost = $pathcost"

    timestamp = Base.Dates.now()
    timestamp = Base.Dates.format(timestamp, "dd u yyyy HH:MM:SS")
    title = " Week 10 PRM [ $timestamp ] \n\n$numSamples samples, connectRadius = $connectRadius, pathcost = $(ceil(pathcost,2))"
    
    graph = algT.Graph(startstate, goalstate, nodeslist, edgeslist)
    # this is the gold
    #!
    rrtPlot = plotfxn.plotRRT(roomPlot, graph, pathNodes, title::String);

####
#startGoal = algT.GraphNode(0, Point(0,0))
#endNode = algT.GraphNode(0, Point(0,0))

end

