#Nodi Attempt to make a PRM.
print("Hello World! ☺ ♫ ☕ \n\n")

using Plots
using DataStructures
#gr()

plot([1,2],[2,3])

module rrt 
    export Node, Edge, Obstacle, Room, Point

    struct Point
        x::Int
        y::Int
    end

    struct Node
        id::Int
        iPrev::Int #parent
        state::Point
    end


    struct Vertex
        id::Int
        state::Point
    end


    struct Edge
        startID::Int
        endID::Int
    end

    struct Edges
        startID::Int
        endIDs::Vector{Vertex}
    end

    struct Obstacle
        SW::Point
        NE::Point
    end

    ### Some types?
    struct Room #corners of the room
        x1::Int
        y1::Int #bottom left corner?
        x2::Int
        y2::Int
        obstacleList::Array{Obstacle}
    end

    struct robot
    end

    struct tempQueueType
        v::rrt.Vertex
        statesList::Vector{rrt.Vertex}
        cost::Int64
    end

    Base.show(io::IO, v::Vertex) = print(io, "V($(v.id), ($(v.state.x),$(v.state.y)))")
    Base.show(io::IO, p::Point) = print(io, "P($(p.x),$(p.y))")
    Base.show(io::IO, q::tempQueueType) = print(io, "Q($(q.v),$(q.statesList) $(q.cost))")
    Base.isless(q1::tempQueueType, q2::tempQueueType) = q1.cost < q2.cost
    Base.isless(p1::Point, p2::Point) = q1.x< q2.x

            
end

function isCollidingNode(pt,obs)
    # this does not work.
    px,py = pt.x, pt.y
    x1,y1 = obs.SW.x, obs.SW.y
    x2,y2 = obs.NE.x, obs.NE.y 

    if (px > x1 && px < x2 && py > y1 && py < y2)
        #print("Node in obstacle, discarded.")
        return true
    else
        return false
    end
end

function isCollidingEdge(r, nn, obs)
    # to detect collision, let's just check whether any of the four
    # lines of the rectangular obstacle intersect with our edge
    # ignore collinearity for now

    # Tofix: To make it look prettier in the graph, I am just going to add a 1 grid pt
    # spacer for now, until I figure out how to check for coincidence of point
    # in line. Or really, I should use GeometryShapes library

    x1,y1 = obs.SW.x, obs.SW.y
    x2,y2 = obs.NE.x, obs.NE.y 

    x1 -= 1
    y1 -= 1
    x2 += 1
    y2 += 1

    pt1 = rrt.Point(x1, y1)
    pt2 = rrt.Point(x1, y2)
    pt3 = rrt.Point(x2, y2)
    pt4 = rrt.Point(x2, y1)
    
    # let A, B be r, nn
    coll1 = intersectLineSeg(r.state, nn.state, pt1, pt2)
    coll2 = intersectLineSeg(r.state, nn.state, pt2, pt3)
    coll3 = intersectLineSeg(r.state, nn.state, pt3, pt4)
    coll4 = intersectLineSeg(r.state, nn.state, pt4, pt1)

    if (!coll1 && !coll2 && !coll3 && !coll4)
        return false
    else
        #print("you're colliding!\n")
        #@show nn
        return true
    end
end

function inGoalRegion(node, goal)
    goal = rrt.Point(18,18)
    n = node.state
    if node == goal
        return true
    end
    distx = abs(n.x - goal.x)
    disty = abs(n.y - goal.y)
    if ( distx < 2 && disty < 2) #radius of goal
        return true
    end
    return false
    
end

function ccw(A,B,C)
    # determines direction of lines formed by three points
	return (C.y-A.y) * (B.x-A.x) > (B.y-A.y) * (C.x-A.x)
end

function intersectLineSeg(A,B,C,D) #no ":" at the end!
 	return ( (ccw(A, C, D) != ccw(B, C, D)) && ccw(A, B, C) != ccw(A, B, D))
end


function nearV(r, nodeslist, maxDist)
    # r is point
    # given maxDist, return all nodes within that distance of node
    nearVs = Vector{rrt.Vertex}()
    for n in nodeslist
        dist = distPt(r.state, n.state)
        if dist < maxDist 
            push!(nearVs, n)
        end
    end
    return nearVs
end


function nearestN(r, nodeslist) #dear lord rewrite this so it doesn't need to pass in maxNodeId
    nearestDist = 9999;

    nearestNode = [];
    for n in nodeslist
        dist = distPt(r, n.state)
        if dist < nearestDist
            nearestDist = dist
            nearestNode = n
        end
    end
    return nearestNode
end


function distPt(pt1, pt2)
    x2,y2 = pt2.x, pt2.y
    x1,y1 = pt1.x, pt1.y
    dist = sqrt( (x1-x2)^2 + (y1-y2)^2 )
    return dist
end



function preprocessPRM(numPts, maxDist)
    #numPts = 100
    #maxDist = 10
    #room = Room(0,0,21,21);

    obs1 = rrt.Obstacle(rrt.Point(8,3),rrt.Point(10,18)) #Todo

    vlist = Vector{rrt.Vertex}()

    nodeslist = Vector{rrt.Vertex}()
    edgeslist = Vector{rrt.Edge}()

    startV = rrt.Vertex(0, rrt.Point(0,0)) #vertex: we just remove the prevID case
    push!(nodeslist, startV)
    #@printf("string %s",nodeslist)

    maxID = 1

    # Sample points, create list of nodes DONE
    for i in 1:numPts
        v = rrt.Point(rand(1:20),rand(1:20)) #new point
        if !isCollidingNode(v, obs1) #todo
            newVertex = rrt.Vertex(maxID, v)
            maxID += 1
            push!(nodeslist, newVertex)
        end
    end

    # Connect each node to its neighboring nodes within a ball or radius r
    for vStart in nodeslist 
        nearlist = nearV(vStart, nodeslist, maxDist) # parent point #TODO
        for vEnd in nearlist
            if !isCollidingEdge(vStart, vEnd, obs1) #todo
                newEdge = rrt.Edge(vStart.id, vEnd.id) #by ID, or just store node? #wait no, i'd have multiple copies of same node for no real reason, mulitple edges per node
                push!(edgeslist, newEdge)
            end
        end
    end

    #@show nodeslist #TODO this shows nodeslist
    #@show edgeslist 
    #@printf("\nPath found? %s Length of nodeslist: %d\n", isPathFound, length(nodeslist))
    return nodeslist, edgeslist
end


function getSuccessors(curVertex, edgeslist, nodeslist) #assuming bidirectional for now
    #curVertex = findNode(nodeID)
    nodeID = curVertex.id
    successorIDs = Vector{Int}()
    successors = Vector{rrt.Vertex}()

    for e in edgeslist
        if e.startID == nodeID
            push!(successorIDs, e.endID)
        end
        #if e.endID == nodeID
        #    push!(successorIDs, e.startID)
        #end
    end

    for id in successorIDs
        vertex = findNode(id, nodeslist)
        push!(successors, vertex)
    end

    return successors
end

function findNodeFromState(nodestate, nodeslist)
    for n in nodeslist
        if n.state == nodestate
            return n
        end
    end
    return Void
end

function fuzzyState(nodestate)
    listFuzzyStates = Vector{rrt.Point}()
    x, y = nodestate.x, nodestate.y
    l = rrt.Point(x-1, y)
    r = rrt.Point(x+1, y)
    u = rrt.Point(x, y+1) 
    d = rrt.Point(x, y-1)
    NW = rrt.Point(x-1, y+1)
    SW = rrt.Point(x-1, y-1)
    NE = rrt.Point(x+1, y+1)
    SE = rrt.Point(x+1, y-1)
    push!(listFuzzyStates, l, r, u, d, NW, SW, NE, SE)
    return listFuzzyStates 
end

function fuzzyFindNodeFromState(nodestate, nodeslist)
    # nodestate x, y += 1
    for n in nodeslist
        nFuzzyState = fuzzyState(n.state)
        if nodestate in nFuzzyState
            return  n
        end
    end
    return Void

end

function queryPRM(beginState, endState, nlist, edgeslist)
    nodeslist = [ rrt.Vertex(101, rrt.Point(1,1)), rrt.Vertex(102, rrt.Point(1,2)), rrt.Vertex(104, rrt.Point(1,4)), 
                  rrt.Vertex(204, rrt.Point(2,4)),  
                  rrt.Vertex(301, rrt.Point(3,1)), rrt.Vertex(302, rrt.Point(3,2)), rrt.Vertex(303, rrt.Point(3,3)), 
                  rrt.Vertex(401, rrt.Point(4,1)), rrt.Vertex(402, rrt.Point(4,2)), rrt.Vertex(404, rrt.Point(4,4)) ]   

    edgeslist = [ rrt.Edge(101,102), rrt.Edge(104, 204), rrt.Edge(301, 302), rrt.Edge(302, 303), 
                 rrt.Edge(302, 402), rrt.Edge(303, 404), rrt.Edge(401,402) ]


    beginState = rrt.Point(4,1)
    endState = rrt.Point(1,4)

    beginVertex = findNodeFromState(beginState, nodeslist)
    endVertex = findNodeFromState(endState, nodeslist)

    print("This is the beginState $(beginState) and the endState $(endState)\n")
    print("This is the beginVertex--> $(beginVertex) >>> and the endVertex--> $(endVertex)\n")

    #@printf("The end state %d, %d could not be found. Using %d, %d instead", endState.x, endState.y, endVertex.x, endVertex.y)
    #aqueue = Queue(rrt.tempQueueType) #how to use queue type

    pathNodes = Vector{rrt.Vertex}()
    visited = Vector{rrt.Vertex}() #nodes we've searched through
    
    foo = rrt.tempQueueType(beginVertex, pathNodes, 1) 
    #frontier = binary_maxheap(rrt.tempQueueType)
    frontier = PriorityQueue() #rrt.tempQueueType, Int
    # Ah! I'm to use heaps instead (specific implementation of priorityqueues)
    enqueue!(frontier, foo, 1) #root node has cost 0  

    while length(frontier) != 0
        #guhh = peek(frontier)
        tmp = DataStructures.dequeue!(frontier)
        curVertex, pathVertices, totaledgecost = tmp.v, tmp.statesList, tmp.cost
        if curVertex == endVertex 
            print("Hurrah! endState reached!")
            return pathVertices #list of nodes in path
        else
            if !(curVertex in visited) #TODO: ask rd if there's better syntax, like "not in", for this
                push!(visited, curVertex)
                # Add all successors to the stack
                for newVertex in getSuccessors(curVertex, edgeslist, nodeslist)
                    @show newVertex
                    newEdgeCost = distPt(curVertex.state, newVertex.state) #heuristic is dist(state,state). better to pass Node than to perform node lookup everytime (vs passing id)
                    f_x = totaledgecost + newEdgeCost + distPt(newVertex.state, endVertex.state) #heuristic = distPt 
                    #push!(pathVertices, newVertex)
                    if !(newVertex in keys(frontier))
                        print("newvertex --> $(newVertex) >>> was not in frontier \n")
                        tmpq = rrt.tempQueueType(newVertex, [], totaledgecost + newEdgeCost)
                        enqueue!(frontier,tmpq,f_x) 
                    end
                end
            end
        end
    end
    # Return None if no solution found
    @printf("This is length of frontier, %d\n", length(frontier))
    return Void
end



function plotPath(isPathFound, nlist) #rewrite so don't need to pass in isPathFound, obs1, rrtstart, goal, room 

    ### <COPIED FOR NOW #Todo fix hardcoding
    obs1 = rrt.Obstacle(rrt.Point(8,5),rrt.Point(10,18)) #Todo

    rrtstart = rrt.Point(1,0)
    goal = rrt.Point(18,18)
    ### / COPIED FOR NOW>


    foo = rand(1)
    h = plot()

    @printf("%s", "plotted\n")
    plot!(h, show=true, legend=false, size=(600,600),xaxis=((-5,25), 0:1:20 ), yaxis=((-5,25), 0:1:20), foreground_color_grid=:lightcyan)

    nIter = -1 #fix hardcoding
    title!("RRT nIter = $(nIter), Path Found $(isPathFound)")

    # plot room
    dim = 21 
    roomx = [0,0,dim,dim];
    roomy = [0,dim,dim,0];
    plot!(roomx, roomy, color=:black, linewidth=5)

    # plot start and end goals
    circle(1,0, 0.5, :red)
    circle(18,18, 1.4, :forestgreen)

    # plot obstacles
    circleObs(obs1)

    # plot all paths


    # plot winning path
    if isPathFound
        cost = plotWinningPath(nlist)
        @printf("\n!!!! the cost of the path was %d across %d nodes  !!!! \n", cost, length(nlist))
        #nEnd = nlist[end]
    end
    for n in nlist
        if n.id == 0
            continue 
        else
            plotEdge(n,nlist)
        end
    end
    # display winning path cost
end

#module pHelp()

    ### Some helper functions
    function circle(x,y,r,c_color)
        th = 0:pi/50:2*pi;
        xunit = r * cos.(th) + x;
        yunit = r * sin.(th) + y;
        plot!(xunit, yunit,color=c_color,linewidth=3.0);
    end

    function circleObs(obstacle)
        x1,y1 = obstacle.SW.x, obstacle.SW.y
        x2,y2 = obstacle.NE.x, obstacle.NE.y
        r = 0.2
        obsColor = :blue

        circle(x1,y1,r,obsColor)
        circle(x1,y2,r,obsColor)
        circle(x2,y1,r,obsColor)
        circle(x2,y2,r,obsColor)

        plot!([x1,x1,x2,x2,x1], [y1,y2,y2,y1,y1], color=obsColor, linewidth=2)
    end

    function plotEdge(n, nlist)
        pt1 = n.state
        iPrev = n.iPrev
        nPrev = findNode(iPrev, nlist) 
        pt2 = nPrev.state
        plot!( [pt1.x, pt2.x],[pt1.y, pt2.y], color=:orange, linewidth=3)
        # Todo: rewrite this to just plot them all at once.... [x1 x2 x3] [y1 y2 y3]
    end

    function costWinningPath(nlist)
        curNode = nlist[end]
        guhPath = [ rrt.Point(curNode.state.x, curNode.state.y)]
        while true
            iPrev = curNode.iPrev
            curNode = findNode(iPrev, nlist)
            x,y = curNode.state.x, curNode.state.y
            push!( guhPath, rrt.Point(x,y))
            if curNode.id == 0
                push!( guhPath, rrt.Point(x,y))
                break
            end
        end
        cost = 0
        for i in 2:length(guhPath)
            cost += distPt(guhPath[i],guhPath[i-1])
        end

        return cost
    end

    function plotWinningPath(nlist)
        curNode = nlist[end]
        xPath = [curNode.state.x]
        yPath = [curNode.state.y]
        guhPath = [ rrt.Point(curNode.state.x, curNode.state.y)]
        while true
            iPrev = curNode.iPrev
            curNode = findNode(iPrev, nlist)
            x,y = curNode.state.x, curNode.state.y
            push!(xPath, x)
            push!(yPath,y)
            push!( guhPath, rrt.Point(x,y))
            if curNode.id == 0
                push!(xPath, x)
                push!(yPath,y)         
                break
            end
        end
        print("plotted winning path")
        cost = 0
        for i in 2:length(guhPath)
            cost += distPt(guhPath[i],guhPath[i-1])
        end

        plot!( xPath, yPath, color = :orchid, linewidth=3)
        #@show nlist
        return cost
    end

    function findNode(id, nodeslist)
        for n in nodeslist
            #TODO: switch nodeslist to use an array, where indice is the ID...
            #this was a really dumb implementation, making a "loop" find
            #instead of taking advantage of fast lookup libraries
            if n.id == id 
                return n
            end
        end
    end
#end

#cost, isPathFound, nlist = rrtPathPlanner(40) #maxIter
# nnodes , maxDist
nodeslist, edgeslist = preprocessPRM(200,10)

start = rrt.Point(0,0)
goal = rrt.Point(18,18)

pathVertices = queryPRM(start, goal, nodeslist, edgeslist) #aStarSearch
@show pathVertices

    #cost = costWinningPath(nodeslist)
    #return cost, isPathFound, nodeslist

#plotPath(is#TODO: switch nodeslist to use an array, where indice is the ID... this was a really dumb implementation, making a "loop" find instead of taking advantage of fast lookup librarie#TODO: switch nodeslist to use an array, where indice is the ID... this was a really dumb implementation, making a "loop" find instead of taking advantage of fast lookup librarie#TODO: switch nodeslist to use an array, where indice is the ID... this was a really dumb implementation, making a "loop" find instead of taking advantage of fast lookup librariesssPathFound,nlist)
