####################################################
 
#  RRT.jl
#  nouyang 2017

####################################################

using Plots
using DataStructures
using GeometryTypes 
using Distributions

using plotfxn
using algT
using algfxn

    numSamples = 200
    connectRadius = 3
	flagOptimal = false
    param = algT.AlgParameters(numSamples, connectRadius)

# pts are pure Points, nodes have ID information
function rrtPlan(room, parameters, startstate, goalstate, obstaclesList)
    roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
    numPts, connectRadius = parameters.numSamples, parameters.connectRadius

    nodeslist = Vector{algT.Node}()
    #edgeslist = Vector{algT.Edge}()
    edgeslist = Vector{LineSegment(Point{2, Float64}, ), Point()}()

    startNode = algT.Node(0, startstate)
    push!(nodeslist, startNode)

    currID = 1 #current node ID

    isPathFound = false

    nn = algT.Node(999999, goalstate)

    for i in 1:numPts
        randPt = algfxn.sampleFree(roomWidth, roomHeight, obstacles)

        nn = algfxn.nearestN(randPt, nodeslist)
        newPt = algfxn.steer(nn.state, randPt, connectRadius) #no node ID yet
        newEdge = alT.Edge(nn.state, newPt) 

        if isFreeMotion(candidateEdge, obstacles, walls)
            newNode = algT.Node(currID, nn.id, newPt) # include parent node id
            currID += 1
            push!(nodeslist, newNode)
            push!(edgeslist, newEdge)
            if algfxn.inGoalRegion(newPt, goalstate)
                isPathFound = true
            end
        end
    end

    print("\n\n - pathfound $isPathFound - \n\n")

    solPath = Vector{algT.Node}()

    goalNode = algT.Node(999999, goalstate)
    push!(solPath, goalNode)

    if isPathFound
        while nowID != 1
            nowID = goalNode.id
            pID = goalNode.parentID
            parentNode = findNode(pID, nodeslist)
            push!(solPath, parentNode)
            nowID = pID
        end
    end

    finalPathCost = algfxn.costPath(pathNodes) 
    return (nodeslist, edgeslist, isPathFound, solPath, finalPathCost)
end

