####################################################
 
#  RRT.jl

#  Implementing PRM and functions for plotting PRM
#  Parameters incude num samples, connection distance, a list of obstacles, and start and goal states
#  Graph search implemented is Astar. Edge cost is assumed to be equal to euclidean distance.
#  To use, call ` include("PRM.jl") ` from any Julia file in the same folder.
#  nouyang 2017

####################################################

using Plots
using DataStructures
using GeometryTypes 
using Distributions

module algT
    using GeometryTypes 
    # export GraphNode, Edge, Obstacle, Room
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
        walls::Vector{LineSegment}
        #walls::HyperRectangle
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

    struct Graph
        startstate::Point{2,Float64}
        goalstate::Point{2,Float64}
        nodeslist::Vector{GraphNode}
        edgeslist::Vector{Edge}
    end

    #Base.show(io::IO, v::Vertex) =# #print(io, "V($(v.id), ($(v.state.x),$(v.state.y)))")
    #Base.show(io::IO, p::Point) =# #print(io, "P($(p.x),$(p.y))")
    #Base.show(io::IO, q::tempQueueType) =# #print(io, "Q($(q.v),$(q.statesList) $(q.cost))")
    Base.isless(q1::queueTmp, q2::queueTmp) = q1.cost < q2.cost
    #Base.isless(p1::Point, p2::Point) = q1.x< q2.x
    #Base.isless(p1::Point, p2::Point) = q1[1] < q2[1]

end


module algfxn 
    using GeometryTypes
    using algT


    function sampleFree(roomW, roomH, obstacles)
        pt_rand = Void

        sampledFree = false
        while !sampledFree
            xrand = rand(Uniform(0, roomW))
            yrand = rand(Uniform(0, roomH))
            pt = Point(xrand, yrand)
            if !algfxn.isCollidingNode(pt, obstacles) # this does NOT check if point is on a line (e.g. a wall)
                pt_rand = Point(xrand, yrand) 
                sampledFree = true
            end
        end

        return pt_rand
    end

    function steer(pt1, pt2, connectRadius)
        # If pt_rand is too far from its nearest node, "truncate" it to be closer
        x1,y1 = pt1
        x2,y2 = pt2 

        theta = atan2((y2-y1) , (x2-x1))
        newX = x1 + connectRadius * cos(theta)
        newY = y1 + connectRadius * sin(theta)

        newPt = Point(newX, newY)
        return newPt
    end

	function ccw(A,B,C)
        # determines direction of lines formed by three points
        return (C[2]-A[2]) * (B[1]-A[1]) > (B[2]-A[2]) * (C[1]-A[1])
    end


    function intersects(line1, line2) #no ":" at the end!
        A, B = line1[1], line1[2]
        C, D = line2[1], line2[2]
        return ( (ccw(A, C, D) != ccw(B, C, D)) && ccw(A, B, C) != ccw(A, B, D))
    end

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

    function isCollidingObstacles(line::LineSegment, obsList::Vector{HyperRectangle})
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

    function isCollidingWalls(line::LineSegment, walls::Vector{LineSegment})
        for wall in walls
            if intersects(line, wall)
                return true
            end
        end
        return false
    end

    function findNearestNodes(nodestate, nodeslist, maxDist)
        # given maxDist, return all nodes within that distance of node
        # list is NOT sorted by distance
        nearestNodes = Vector{Tuple{algT.GraphNode, Float64}}()
        for n in nodeslist
            dist = min_euclidean(Vec(nodestate), Vec(n.state))
            if dist < maxDist 
                push!(nearestNodes, (n, dist))
            end
        end
        return nearestNodes 
    end

    function nearestN(pt::Point{2,Float64}, nodeslist)
        # 
        # This loops through all nodes 
        nearestDist = 99999999;
        nearestNode = Void;

        for n in nodeslist
            dist = min_euclidean(Vec(pt), Vec(n.state))
            if dist < nearestDist
                nearestDist = dist
                nearestNode = n
            end
        end
        return nearestNode
    end

    function inGoalRegion(pt, pt_goal)
        if pt == pt_goal
            return true
        else 
            dist = min_euclidean(Vec(pt), Vec(pt_goal))
            if dist <= 2
                return true
            end
        end
        
        return false
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
        # Assumes we have not removed any nodes, hence we can sort by ID
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
        aPlot = plot() #Todo! this assumes plotroom is first thing called()
        roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
       # #print("\nPlotting Room\n")
        plot!(aPlot, walls, color =:black)
        plot!(aPlot, obstacles, fillalpha=0.5)
        return aPlot
    end

    function plotRRT(roomPlot, nodeslist, solPath, title)
        startstate, goalstate, nodeslist, edgeslist = roadmap.startstate, roadmap.goalstate, roadmap.nodeslist, roadmap.edgeslist

        x = [n.state[1] for n in nodeslist]
        y = [n.state[2] for n in nodeslist]
        scatter!(roomPlot, x,y, color=:black) 

        edgeXs, edgeYs = [], []
        for e in edgeslist
            startN = algfxn.findNode(e.startID, nodeslist)
            endN = algfxn.findNode(e.endID, nodeslist)
            x1,y1 = startN.state[1], startN.state[2]
            x2,y2 = endN.state[1], endN.state[2]
            push!(edgeXs, x1, x2, NaN) #the NaNs, keep spaces between edges correctly unplotted
            push!(edgeYs, y1, y2, NaN)
        end

        plot!(roomPlot, edgeXs, edgeYs, color=:tan, linewidth=0.3)

        # plot solution
        rrtPlot = plotSolPath(roomPlot, solPath)
        
        title!(rrtPlot, title)
        plot!(rrtPlot, legend=false, size=(600,600), xaxis=((-5,25), 0:1:20 ), 
              yaxis=((-5,25), 0:1:20), foreground_color_grid= :black)
        return rrtPlot
    end

    function plotSolPath(aPlot, solPath)
        print("\n ---Solution Path----- \n")
        #@show solPath
        print("\n -------- \n")
        if solPath != Void
            xPath = [n.state[1] for n in solPath] 
            yPath = [n.state[2] for n in solPath]
            xstart, ystart = solPath[1].state
            xend, yend = solPath[end].state
            # plot start pt
            scatter!(aPlot, [xstart], [ystart], 
                     markercolor= :red, markershape = :circle,  markersize = 6, markerstrokealpha = 0.5, markerstrokewidth=1)
            # plot goal pt
            scatter!(aPlot, [xend], [yend], 
                     markerstrokecolor = :green, markershape = :star,  markersize = 5, markerstrokealpha = 1, markerstrokewidth=5)

            # plot path
            plot!(aPlot, xPath, yPath, color = :orchid, linewidth=3, fillalpha = 0.3)
        else
           # #print("\n --- No solution path found ----- \n")
        end

        return aPlot
    end


end


function rrtPlan(room, parameters, startstate, goalstate, obstaclesList)
    roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
    numPts, connectRadius = parameters.numSamples, parameters.connectRadius

    nodeslist = Vector{algT.GraphNode}()
    edgeslist = Vector{algT.Edge}()

    startNode = algT.GraphNode(0, startstate)
    push!(nodeslist, startNode)

    currID = 1 #current node ID

    # for numPts iterations...
    for i in 1:numPts

        # Sample node from free space
        pt_rand = algfxn.sampleFree(roomWidth, roomHeight, obstacles)

        # Find nearest existing node
        n_nearest = algfxn.nearestN(pt_rand, nodeslist)

        # Steer 
        pt_new = algfxn.steer(pt_rand, n_nearest.state) #no node ID yet

        # edge going FROM nearest in tree TO new node
        candidateEdge = LineSegment(n_nearest.state, pt_new)


            # Note: Alternate implementation: for RRT we do not *need* edges list
            # if we include a parent ID for each node.
            # Here we just make an edge
            # Currently we will have to loop through all edges to trace the solution path
        if (    !algfxn.isCollidingObstacles(candidateEdge, obstacles) 
              & !algfxn.isCollidingWalls(candidateEdge, walls) )
            n_new = algT.GraphNode(currID, pt_new)
            currID += 1
            newEdge = algT.Edge(n_new.id, n_nearest.id) 
            push!(nodeslist, n_new)
            push!(edgeslist, newEdge)
        end

        if algfxn.inGoalRegion(pt_new, goalstate)
            isPathFound = true
            break
        end
    end

    pathNodes = Vector{algT.GraphNode}()

    if isPathFound
        ## CREATE LIST OF NODES IN THE FEASIBLE PATH

        pt_goal = goalstate
        n_last = n_new #the last node added is the one in the goal region
        push!(pathNodes, n_last)

        # node =  What to initalize to ??
        currPathID = n_last.id

        # Loop until we reach the start node
        while currPathID != 0

            # Find the parent node ID, add associated node to list
            for edge in edgeslist
                if edge.endID == currPathID
                    node = algfxn.findNode(edge.startID, nodeslist)
                    push!(pathNodes, node)
                # Todo! do NOT fail silently if no edge is found, or if more than one edge is found (in RRT)
                # can i use `break` here?
                end
            end
            currPathID = node.id
        end

    else
        # if no feasible path was found, just return the start and end nodes so we can plot them
        push!(pathNodes, startNode)
        goalNode = algT.GraphNode(999999, goalstate)
        push!(pathNodes,goalNode)
    end

    finalPathCost = algfxn.costPath(pathNodes) #Assuming edge cost is Euclidean cost
    return (finalPathCost, isPathFound, pathNodes)

end

