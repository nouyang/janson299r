using Plots
using DataStructures
using GeometryTypes 

gr()

module alg
    using GeometryTypes 
    #export GraphNode, Edge, Obstacle, Room
    # struct PointAlg
        # x::Int64
        # y::Int64

    struct GraphNode
        id::Int64
        state::Point{2, Float64}
    end

    struct Edge
        startid::Int64
        endid::Int64
        #edge::LineSegment(Point{2, Float64}, Point{2, Float64})
        edge::LineSegment{}
    end

    struct Obstacle
        id::Int64
        rect::HyperRectangle{2, Vec}
        #color
        #fillalpha
    end

    struct Room
        width::Int64
        height::Int64
        #walls::Vector{LineSegment{Point}}
        walls::HyperRectangle
        obstacles::Vector{HyperRectangle}
    end

    struct AlgParameters
        #startGoal::Point{2, Float64}
        #endGoal::Point{2, Float64}
        numSamples::Int64
        connectRadius::Int64
        # goal region?? should be rectangle? aka error from goal allowed
    end

    struct queueTmp
        v::Point{2, Float64}
        statesList::Vector{Point{2, Float64}}
        cost::Int64
    end

    #Base.show(io::IO, v::Vertex) = print(io, "V($(v.id), ($(v.state.x),$(v.state.y)))")
    #Base.show(io::IO, p::Point) = print(io, "P($(p.x),$(p.y))")
    #Base.show(io::IO, q::tempQueueType) = print(io, "Q($(q.v),$(q.statesList) $(q.cost))")
    Base.isless(q1::queueTmp, q2::queueTmp) = q1.cost < q2.cost
    #Base.isless(p1::Point, p2::Point) = q1.x< q2.x
    #Base.isless(p1::Point, p2::Point) = q1[1] < q2[1]
end


module algfxn 
    using GeometryTypes
    using alg

    function decompRect(r::HyperRectangle) #GeometryTypes.HyperRectangle{2,Float64}
        corners = decompose(Point{2, Float64}, r)
        corners = [Point(pt) for pt in corners]
        lineBottom  = LineSegment(corners[1], corners[2])
        lineTop     = LineSegment(corners[3], corners[4])
        lineLeft    = LineSegment(corners[1], corners[3])
        lineRight   = LineSegment(corners[2], corners[4])
        lines = Vector{LineSegment}()
        push!(lines, lineTop, lineRight, lineBottom, lineLeft)
        return lines
    end


    #function isCollidingNode(node::alg.GraphNode, obsList::Vector{alg.Obstacle}
    function isCollidingNode(node::Point{2, Float64}, obsList::Vector{HyperRectangle})
        for obs in obsList
            if in(obs, node)
                return true
            end
        end
        return false
    end

    function isCollidingEdge(edge::LineSegment, obsList::Vector{HyperRectangle})
        for obs in obsList
            rectLines = decompRect(obs)
            for line in rectLines
                if intersects(edge, line)[1]
                    return true
                end
            end
        end
        return false
    end


    function findNearestNodes(nodestate, nodeslist, maxDist)
        # given maxDist, return all nodes within that distance of node
        nearestNodes = Vector{Tuple{alg.GraphNode, Float64}}()
        for n in nodeslist
            dist = min_euclidean(Vec(nodestate), Vec(n.state))
            if dist < maxDist 
                push!(nearestNodes, (n, dist))
            end
        end
        # return list sorted by distance?
        # or just return list with distances included for now...
        return nearestNodes 
    end


end

function preprocessPRM(room, parameters) 
    roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
    numPts, connectRadius = parameters.numSamples, parameters.connectRadius

    nodeslist = Vector{alg.GraphNode}()
    edgeslist = Vector{alg.Edge}()

    currID = 1

    # Sample points, create list of nodes 
    for i in 1:numPts
        n = Point(rand(1.:roomWidth),rand(1.:roomHeight)) #new point in room
        if !algfxn.isCollidingNode(n, obstacles) #todo
            newNode = alg.GraphNode(currID, n)
            currID += 1
            push!(nodeslist, newNode)
        end
    end

    # Connect each node to its neighboring nodes within a ball or radius r, creating edges
    for startnode in nodeslist 
        neighbors = [item[1] for item in algfxn.findNearestNodes(startnode.state, nodeslist, connectRadius)] # parent point #TODO
        n = [algfxn.findNearestNodes(startnode.state, nodeslist, connectRadius)] # parent point #TODO
        for endnode in neighbors
            candidateEdge = LineSegment(startnode.state, endnode.state)
            if !algfxn.isCollidingEdge(candidateEdge, obstacles) #todo
                line = LineSegment(startnode.state, endnode.state)
                newEdge = alg.Edge(startnode.id, endnode.id, line) #by ID, or just store node? #wait no, i'd have multiple copies of same node for no real reason, mulitple edges per node
                push!(edgeslist, newEdge)
            end
        end
    end

    #@show edgeslist 
    #@printf("\nPath found? %s Length of nodeslist: %d\n", isPathFound, length(nodeslist))
    return nodeslist, edgeslist
end


function plotRoom(room, nodeslist, edgeslist)
    roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
    plot!(walls)
    plot!(obstacles)
end


function main()
    print("Hi")

    ## Definte room
    obs1 = HyperRectangle(Vec(8,3.), Vec(2,15.)) #Todo
    obstacles = Vector{HyperRectangle}()
    push!(obstacles, obs1)

    w,h  = 21,21
    walls = HyperRectangle(Vec(0.,0), Vec(w,h))

    r = alg.Room(w,h,walls,obstacles)
    numSamples = 10
    connectRadius = 10
    param = alg.AlgParameters(10,10)

    ## Run preprocessing
    nodeslist, edgeslist = preprocessPRM(r, param)

    ## Plot preprocessing results

    plotRoom(r, nodeslist, edgeslist)

    ## Query PRM
    #queryPRM(Point(0.,0), Point(18.,18), nodeslist, edgeslist)

####
#startGoal = alg.GraphNode(0, Point(0,0))
#endNode = alg.GraphNode(0, Point(0,0))

end

module recipes()
using GeometryTypes
using Plots

    sizePlot = (400,400)
    plot(opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10), foreground_color_grid= :cyan) 

@recipe function f(r::HyperRectangle)
    points = decompose(Point{2,Float64}, r)
    rectpoints = points[[1,2,4,3],:]
    xs = [pt[1] for pt in rectpoints];
    ys = [pt[2] for pt in rectpoints];
    seriestype := :shape
    color = :orange
	#m = (:black, stroke(0))
	s = Shape(xs[:], ys[:])
end

@recipe function f(pt::Point)
    xs = [pt[1]]
    ys = [pt[2]]
    seriestype --> :scatter
    color := :orange
    markersize := 6
    xs, ys
end
 
@recipe function f(l::LineSegment)
    xs = [ l[1][1], l[2][1] ]
    ys = [ l[1][2], l[2][2] ]
    # seriestype = :line
    color = :red
    lw := 3
    xs, ys
end


@recipe function f(rectList::Vector{<:HyperRectangle})
    for r in rectList
	  @series begin
         r 
	  end
   end
end

@recipe function f(ptList::Vector{<:Point})
    for p in ptList
	  @series begin
         p
	  end
   end
end

@recipe function f(lineList::Vector{<:LineSegment})
    for l in lineList 
	  @series begin
         l 
	  end
   end
end
end 
main()

# 
# function getSuccessors(curNode, edgeslist, nodeslist) #assuming bidirectional for now
    # nodeID = curNode.id
    # successorIDs = Vector{Int}()
    # successors = Vector{Point}()
# 
    # for e in edgeslist
        # if e.startID == nodeID
            # push!(successorIDs, e.endID)
        # end
        # if e.endID == nodeID #should I include endID? it is bidirectional after all. 
            # push!(successorIDs, e.startID) #yes, because local planner connects in bidirectional way
        # end
    # end
# 
    # for id in successorIDs
        # node = findNode(id, nodeslist)
        # push!(successors, node)
    # end
# 
    # return successors
# end
# 
# function queryPRM( startstate, goalstate, nodeslist, edgeslist)
    # # to find nearest node, set connect radius to be infinity for now #todo
    # connectRadius = 99;
    # nearstart = algfxn.findNearestNodes(startstate, nodeslist, connectRadius) # parent point #TODO
    # nodestart = sort(nearstart, by=nearstart->nearstart[2])[1][1]
    # neargoal = algfxn.findNearestNodes(goalstate, nodeslist, connectRadius) # parent point #TODO
    # nodegoal = sort(neargoal, by=neargoal->neargoal[2])[1][1]
# 
    # print("This is the beginState $(startstate) and the endState $(goalstate)\n")
    # print("This is the beginVertex--> $(nodestart) >>> and the endVertex--> $(nodegoal)\n")
# end
# 


# function queryPRM(beginState, endState, nlist, edgeslist)
    # foo = rrt.queueTmp(nodestart, pathNodes, 1) 
    # frontier = PriorityQueue() #rrt.tempQueueType, Int
    # enqueue!(frontier, foo, 1) #root node has cost 0  
	# zcost = 99999
# 
    # while length(frontier) != 0
        # tmp = DataStructures.dequeue!(frontier)
        # pathVertices = []
        # currNode, pathVertices, totaledgecost = tmp.v, tmp.statesList, tmp.cost
# 
        # if curVertex == endVertex 
            # print("Hurrah! endState reached! \n")
            # unshift!(pathVertices, beginVertex) #prepend startVertex back to pathVertices
			# zcost = costPath(pathVertices)
            # return (zcost, true, pathVertices) #list of nodes in solution path
# 
        # else
            # #@show visited
            # #@show curVertex
            # if !(curVertex in visited) 
                # #print("curVertex not in visited\n")
                # push!(visited, curVertex) # Add all successors to the stack
# 
                # for newVertex in getSuccessors(curVertex, edgeslist, nlist)
                # #print("\n")
                # #print("newvertex --> $(newVertex) \n")
                    # newEdgeCost = distPt(curVertex.state, newVertex.state) #heuristic is dist(state,state). better to pass Node than to perform node lookup everytime (vs passing id)
                    # f_x = totaledgecost + newEdgeCost + distPt(newVertex.state, endVertex.state) #heuristic = distPt 
                    # p = deepcopy(pathVertices)
                    # push!(p,newVertex)
                # #@show pathVertices
                    # if !(newVertex in keys(frontier))
                        # #print("newvertex --> $(newVertex) >>> was not in frontier \n")
                        # tmpq = rrt.tempQueueType(newVertex, p, ceil(totaledgecost + newEdgeCost))
                        # enqueue!(frontier,tmpq, ceil(f_x)) 
                        # #print("Added state --> $(tmpq) >>> to frontier \n")
                        # #print("This is frontier top --> $(peek(frontier)) \n")
                    # end
                # end
# 
            # end
        # end
    # end    
    # # Return None if no solution found
    # #@printf("No solution found! This is length of frontier, %d\n", length(frontier))
	# zcost = 99999
    # return (zcost, false, Void)
# end
# 
