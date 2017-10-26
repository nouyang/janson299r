using Plots
using DataStructures
using GeometryTypes 
using Distributions
gr()

module algT
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
        startID::Int64
        endID::Int64
        #edge::LineSegment(Point{2, Float64}, Point{2, Float64})
        #edge::LineSegment{}
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
        #pt::Point{2, Float64}
        node::algT.GraphNode
        statesList::Vector{algT.GraphNode}
        cost::Int64
    end

    struct roadmap
        startstate::Point{2,Float64}
        goalstate::Point{2,Float64}
        nodeslist::Vector{GraphNode}
        edgeslist::Vector{Edge}
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
    using algT

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


    #function isCollidingNode(node::algT.GraphNode, obsList::Vector{algT.Obstacle}
    function isCollidingNode(node::Point{2, Float64}, obsList::Vector{HyperRectangle})
        for obs in obsList
            if contains(obs, node)
                return true
            end
        end
        return false
    end

    function isCollidingEdge(line::LineSegment, obsList::Vector{HyperRectangle})
        for obs in obsList
            rectLines = decompRect(obs)
            for rectline in rectLines
                if intersects(line, rectline)[1]
                    return true
                end
            end
        end
        return false
    end


    function findNearestNodes(nodestate, nodeslist, maxDist)
        # given maxDist, return all nodes within that distance of node
        nearestNodes = Vector{Tuple{algT.GraphNode, Float64}}()
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
    
    function costPath(solPath)
        pathcost = 0
        for i in 2:length(solPath)
            curN  = solPath[i].state
            prevN = solPath[i-1].state
            pathcost += min_euclidean(Vec(curN), Vec(prevN))
        end
        return pathcost
    end

    function findNode(nodeID, nodeslist)
        #since we haven't removed any nodes, nodeslist should be sorted by index. but just in case, let's search through it
        index = findfirst([node.id for node in nodeslist], nodeID)
        return nodeslist[index]
    end

end

module plotfxn

    using GeometryTypes
    using Plots
    using algfxn
    using algT

    ###  Plots.jl recipes

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
        color = :orange
        markersize := 3
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


    ####

    function plotRoom(room)
        roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
        plot()
        print("\nPlotting Room\n")
        plot!(walls, fillalpha=0.1)
        plot!(obstacles, fillalpha=0.5)
    end

    function plotPRM(roadmap, solPath, title)
        startstate, goalstate, nodeslist, edgeslist = roadmap.startstate, roadmap.goalstate, roadmap.nodeslist, roadmap.edgeslist

        x = [n.state[1] for n in nodeslist]
        y = [n.state[2] for n in nodeslist]
        scatter!(x,y, color=:black) 

        edgeXs, edgeYs = [], []
        for e in edgeslist
            startN = algfxn.findNode(e.startID, nodeslist)
            endN = algfxn.findNode(e.endID, nodeslist)
            x1,y1 = startN.state[1], startN.state[2]
            x2,y2 = endN.state[1], endN.state[2]
            push!(edgeXs, x1, x2, NaN) #the NaNs, keep spaces between edges correctly unplotted
            push!(edgeYs, y1, y2, NaN)
        end

        plot!( edgeXs, edgeYs, color=:tan, linewidth=0.3)
        # todo: path cost should actually include distance from stand end to nearest nodes in the graph

        plotSolPath(solPath)
        
        title!(title)
    end

    function plotSolPath(solPath)
        #print("\n ---Solution Path----- \n")
        #@show solPath
        #print("\n -------- \n")
        if solPath != Void
            xPath = [n.state[1] for n in solPath] 
            yPath = [n.state[2] for n in solPath]
            xstart, ystart = solPath[1].state
            xend, yend = solPath[end].state
            # plot start pt
            scatter!([xstart], [ystart], 
                     markercolor= :red, markershape = :circle,  markersize = 6, markerstrokealpha = 0.5, markerstrokewidth=1)
            # plot goal pt
            scatter!([xend], [yend], 
                     markerstrokecolor = :green, markershape = :star,  markersize = 5, markerstrokealpha = 1, markerstrokewidth=5)

            # plot path
            plot!( xPath, yPath, color = :orchid, linewidth=3)
        else
            print("\n --- No solution path found ----- \n")
        end
    end


end

function preprocessPRM(room, parameters) 
    roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
    numPts, connectRadius = parameters.numSamples, parameters.connectRadius

    nodeslist = Vector{algT.GraphNode}()
    edgeslist = Vector{algT.Edge}()

    currID = 1

    # Sample points, create list of nodes 
    for i in 1:numPts
        xrand = rand(Uniform(1, roomWidth-1))
        yrand = rand(Uniform(1, roomWidth-1))
        n = Point(xrand, yrand) #new point in room
        if !algfxn.isCollidingNode(n, obstacles) #todo
            newNode = algT.GraphNode(currID, n)
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
                #line = LineSegment(startnode.state, endnode.state)
                newEdge = algT.Edge(startnode.id, endnode.id) #by ID, or just store node? #wait no, i'd have multiple copies of same node for no real reason, mulitple edges per node
                push!(edgeslist, newEdge)
            end
        end
    end

    #@show edgeslist 
    #@printf("\nPath found? %s Length of nodeslist: %d\n", isPathFound, length(nodeslist))
    return nodeslist, edgeslist
end

function getSuccessors(curNode, edgeslist, nodeslist) #assuming bidirectional for now
    #Find all edges that start or end at current node, and then make a list of the corresponding start or end nodes
    nodeID = curNode.id
    successorNodeIDs = Vector{Int}()
    successors = Vector{algT.GraphNode}()

    for e in edgeslist
        if e.startID == nodeID
            push!(successorNodeIDs, e.endID)
        end
        if e.endID == nodeID #should I include endID? it is bidirectional after all. 
            push!(successorNodeIDs,  e.startID) #yes, because local planner connects in bidirectional way
        end
    end

    for id in successorNodeIDs
        node = algfxn.findNode(id, nodeslist)
        push!(successors, node)
    end

    return successors
end

function queryPRM(startstate, goalstate, nodeslist, edgeslist, obstaclesList)
    # to find nearest node, set connect radius to be infinity for now #todo
    connectRadius = 99;
    n_nearStart= algfxn.findNearestNodes(startstate, nodeslist, connectRadius) #Get distance from start, for all points in graph.
    n_nearGoal= algfxn.findNearestNodes(goalstate, nodeslist, connectRadius) 

    #remove nodes that we cannot reach in a straight line without going through an obstacle
    #todo: this is expensive, we should only check distances in order

    # n_nearStart is tuple of node and distance
    sort!(n_nearStart, by=n_nearStart->n_nearStart[2]) #Sort by distance and pick node with smallest distance from start
    sort!(n_nearGoal, by=n_nearGoal->n_nearGoal[2])
    #print("\n ----------------- \n")
    #@show n_nearStart
    #print("\n ----------------- \n")
    #@show n_nearGoal

    nodestart = algT.GraphNode(9999,Point(9999,9999))
    nodegoal = algT.GraphNode(9999,Point(9999,9999))

    for (n, dist) in n_nearStart 
        # bar = typeof(startstate)
        # bar2 = typeof(n)
        # print("\n$bar, $bar2\n")
        candidateline = LineSegment(Point(startstate), Point(n.state))
        if !algfxn.isCollidingEdge(candidateline, obstaclesList)
            nodestart = n
            break
        end
    end

    for (n, dist) in n_nearGoal
        candidateline = LineSegment(Point(goalstate), n.state)
        if !algfxn.isCollidingEdge(candidateline, obstaclesList)
            nodegoal = n
            break
        end
    end


    if nodestart == algT.GraphNode(9999,Point(9999,9999))
        nodestart = algT.GraphNode(0, Point(0,0))
        print("ahhhhhh didn't find a start node")
    end
    if nodegoal == algT.GraphNode(9999,Point(9999,9999))
        nodegoal = algT.GraphNode(0, Point(0,0))
        print("ahhhhhh didn't find a goal node")
    end


    print("This is the beginState $(startstate) and the endState $(goalstate)\n")
    print("This is the beginVertex--> $(nodestart) >>> and the endVertex--> $(nodegoal)\n")


    pathNodes = Vector{algT.GraphNode}()
    visited = Vector{algT.GraphNode}() #nodes we've searched through

    frontier = PriorityQueue()
    queue1 = algT.queueTmp(nodestart, pathNodes, 1) 
    enqueue!(frontier, queue1, 1) #root node has cost 0  
    pathcost = 99999

    #################### A star search
    while length(frontier) != 0
        front = DataStructures.dequeue!(frontier)
        pathVertices = []

        curNode, pathNodes, totalEdgeCost = front.node, front.statesList, front.cost

        if curNode == nodegoal
            print("Hurrah! endState reached! \n")
            unshift!(pathNodes, nodestart) #prepend our first path node back to pathVertices
            unshift!(pathNodes, algT.GraphNode(0, startstate)) #prepend the start 
            push!(pathNodes, algT.GraphNode(0, goalstate)) #append the goal 
            finalPathCost = algfxn.costPath(pathNodes) #Assuming edge cost is Euclidean cost
            isPathFound = true
            return (finalPathCost, isPathFound, pathNodes) #list of nodes in solution path

        else
            if !(curNode in visited) 
                push!(visited, curNode) # Add all successors to the stack

                for candidateNode in getSuccessors(curNode, edgeslist, nodeslist)
                    newEdgeCost = min_euclidean(Vec(curNode.state),
                                                Vec(candidateNode.state))
                    #edgecost is euclidean dist(state,state). better to pass
                   # Node than to perform node lookup everytime (vs passing id)
                    f_x = totalEdgeCost + newEdgeCost + min_euclidean(Vec(candidateNode.state), Vec(nodegoal.state)) #heuristic = euclidean distance to end goal
                    p = deepcopy(pathNodes)
                    push!(p, candidateNode)
                    if !(candidateNode in keys(frontier))
                        newQ = algT.queueTmp(candidateNode, p, ceil(totalEdgeCost+ newEdgeCost))
                        enqueue!(frontier, newQ, ceil(f_x)) 
                    end
                end

            end
        end
    end    

    # Return None if no solution found
    #@printf("No solution found! This is length of frontier, %d\n", length(frontier))
    finalPathCost = Void
    isPathFound = false
    pathNodes = Void
    return (finalPathCost, isPathFound, pathNodes)
end


####################
####################

function main()
    print("\n ---- Running PRM ------ \n")
    ## Define room
    obs1 = HyperRectangle(Vec(8,3.), Vec(2,2.)) #Todo
    obs2 = HyperRectangle(Vec(4,4.), Vec(2,10.)) #Todo

    obstacles = Vector{HyperRectangle}()
    push!(obstacles, obs1, obs2)

    w,h  = 20,20
    walls = HyperRectangle(Vec(0.,0), Vec(w,h))

    r = algT.Room(w,h,walls,obstacles)
    numSamples = 25
    connectRadius =10 
    param = algT.AlgParameters(numSamples, connectRadius)

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

    plot!(legend=false, size=(600,600),xaxis=((-5,25), 0:1:20 ), yaxis=((-5,25), 0:1:20), foreground_color_grid=:black)

####
#startGoal = algT.GraphNode(0, Point(0,0))
#endNode = algT.GraphNode(0, Point(0,0))

end

main()
