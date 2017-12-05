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

    startNode = algT.Node(0, algT.Pt2D(startstate), 0) #id, state, parentid
    push!(nodeslist, startNode)

    currID = 1 #current node ID

    isPathFound = false

    nn = algT.Node(99999, goalstate, -99999)
    newNode = nothing 
    endNode = nothing 

    for i in 1:numPts
            print("\n ------------------------ \n")
        randPt = algfxn.sampleFree(roomWidth, roomHeight, obstacles)

        nn = algT.Node(algfxn.nearestN(randPt, nodeslist))
        newPt = algfxn.steer(nn.state, randPt, connectRadius) #no node ID yet
        newMove = LineSegment(Point(nn.state), Point(newPt))
        if algfxn.isFreeMotion(newMove, obstacles, walls)
            newNode = algT.Node(currID, newPt, nn.id ) # include parent node id
            newEdge = algT.Edge(nn, newNode)
            currID += 1
            push!(nodeslist, newNode)
            push!(edgeslist, newEdge)
            if algfxn.inGoalRegion(newPt, goalstate)
                print("\n --goal found! $newPt, goal is $goalstate-- \n")
                endNode = newNode
                isPathFound = true
                break
            end
        end
    end


    ## Collect Paths
    print("\n\n - pathfound $isPathFound - \n\n")

    solPath = Vector{algT.Node}()

    # TODO handle this more gracefully
    if endNode != nothing
        goalNode = algT.Node(currID+1, goalstate, endNode.id)
    else
        goalNode = algT.Node(currID+1, goalstate)
    end
    push!(solPath, goalNode)

    if isPathFound
        pID = goalNode.parentID
        node = []
        while true 
            node = algfxn.findNode(pID, nodeslist)
            pID = node.parentID
            push!(solPath, node)
            if node.id == 0
                break
            end
        end
    end

    #@show edgeslist
    #@show nodeslist
    @show solPath

    finalPathCost = algfxn.costPath(solPath) 
    return (nodeslist, edgeslist, isPathFound, solPath, finalPathCost)
end

