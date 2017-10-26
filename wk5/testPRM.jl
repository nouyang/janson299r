####################################################

#  This file is used for development and testing of PRM.jl. 
#  It runs the PRM once and plots the results.
#  nouyang 2017

####################################################
# MAIN
####################################################
include("PRM.jl")

function main()
    numSamples = 25
    connectRadius =10 
    param = algT.AlgParameters(numSamples, connectRadius)

    print("\n ---- Running PRM ------ \n")
    ## Define obstacles
    obs1 = HyperRectangle(Vec(8,3.), Vec(2,2.)) #Todo
    obs2 = HyperRectangle(Vec(4,4.), Vec(2,10.)) #Todo

    obstacles = Vector{HyperRectangle}()
    push!(obstacles, obs1, obs2)

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

    ## Run preprocessing
    nodeslist, edgeslist = preprocessPRM(r, param)

    ## Plot preprocessing results

    plotfxn.plotRoom(r)

    # todo: could write a queryPRM that takes a set of start and goal nodes, and returns answers for all of them
    ## Query created RM
    startstate = Point(1.,1)
    goalstate = Point(18.,18)

    pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)

    ## Plot path found
    title = "PRM with # samples =$numSamples, \nPathfound = $isPathFound, \npathcost = $pathcost"
    roadmap = algT.roadmap(startstate, goalstate, nodeslist, edgeslist)

    plot = plotfxn.plotPRM(roadmap, solPath, title::String)

    plot!(legend=false, size=(600,600),xaxis=((-5,25), 0:1:20 ), yaxis=((-5,25), 0:1:20), foreground_color_grid= :black)

####
#startGoal = algT.GraphNode(0, Point(0,0))
#endNode = algT.GraphNode(0, Point(0,0))

end


########################################
# Call main() function
########################################   

main()
