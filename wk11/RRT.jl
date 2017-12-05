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

# pts are pure Points, nodes have ID information
function rrtPlan(room, parameters, startstate, goalstate, obstaclesList)
    roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
    numPts, connectRadius = parameters.numSamples, parameters.connectRadius

    nodeslist = Vector{algT.Node}()
    edgeslist = Vector{algT.Edge}()

    startNode = algT.Node(0,algT.Pt2D(startstate),0) #id, state, parentid
    push!(nodeslist, startNode)

    currID = 1 #current node ID

    isPathFound = false

    nn = algT.Node(99999, goalstate, -99999)
    newNode = nothing 

    for i in 1:numPts
            print("\n --- ---------------------- \n")
        randPt = algfxn.sampleFree(roomWidth, roomHeight, obstacles)

        nn = algT.Node(algfxn.nearestN(randPt, nodeslist))
        newPt = algfxn.steer(nn.state, randPt, connectRadius) #no node ID yet
        newMove = LineSegment(Point(nn.state), Point(newPt))
            print("\n --- move: $newMove --- \n")

        if algfxn.isFreeMotion(newMove, obstacles, walls)
            newNode = algT.Node(currID, newPt, nn.id ) # include parent node id
            newEdge = algT.Edge(nn, newNode)
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

    goalNode = algT.Node(currID+1, goalstate, nodeslist[end].id)
    push!(solPath, goalNode)

    if isPathFound
        nowID = goalNode.id
        pID = goalNode.parentID
        while nowID != 1
            node = algfxn.findNode(pID, nodeslist)
            pID = node.parentID
            push!(solPath, node)
            nowID = pID
        end
    end
    @show edgeslist
    @show nodeslist

    finalPathCost = algfxn.costPath(solPath) 
    return (nodeslist, edgeslist, isPathFound, solPath, finalPathCost)
end

