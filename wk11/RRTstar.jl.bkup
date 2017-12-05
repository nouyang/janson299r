####################################################
 
#  RRTstar.jl

#  Implementing RRTstar 
#  nouyang 2017

####################################################

using Plots
using DataStructures
using GeometryTypes 
using Distributions

module algT
    using GeometryTypes 
    # export GraphNode, Edge, Obstacle, Room

    struct GraphNode
        id::Int64
        state::Point{2, Float64}
    end

    mutable struct TreeNode 
        id::Int64
        parentID::Int64
        state::Point{2, Float64}
        cost::Float64
        TreeNode() = new()
    end

    struct Edge
        startID::Int64
        endID::Int64
    end

    struct Obstacle
        id::Int64
        rect::HyperRectangle{2, Vec}
    end

    struct Room
        width::Int64
        height::Int64
        walls::Vector{LineSegment}
        obstacles::Vector{HyperRectangle}
    end

    struct AlgParameters
        numSamples::Int64
        connectRadius::Int64
    end
#  
    struct queueTmp
        node::algT.GraphNode
        statesList::Vector{algT.GraphNode}
        cost::Int64
    end
#  
    struct Graph
        startstate::Point{2,Float64}
        goalstate::Point{2,Float64}
        # TODO
        nodeslist::Vector{TreeNode}
        edgeslist::Vector{Edge}
    end

    Base.isless(q1::queueTmp, q2::queueTmp) = q1.cost < q2.cost
#  
end


module algfxn 
    using GeometryTypes
    using Distributions
    using algT

    function dist(pt1, pt2)
        return min_euclidean(Vec(pt1), Vec(pt2)) 
    end
                  

    function chooseParent(nearestN, newNode,  nodeslist, connectRadius)
        for n in nodeslist
            pt = n.state
            #@show pt
            #@show newNode
            #@show connectRadius #Todo! cast int to float
            #asdf = min_euclidean(Vec(pt), Vec(newNode.state))
            #@show asdf
            #print("type: $(typeof(asdf))")
            if (min_euclidean(Vec(pt), Vec(newNode.state)) < connectRadius ) && 
                (n.cost + min_euclidean(Vec(pt), Vec(newNode.state)) < nearestN.cost + min_euclidean(Vec(nearestN.state), Vec(pt)))
                nearestN = n
            end
        end
        newNode.cost = nearestN.cost + min_euclidean(Vec(nearestN.state), Vec(newNode.state))
        newNode.parentID = nearestN.id
        return newNode, nearestN
    end

    function rewire(nodeslist, edgeslist, newNode, connectRadius, obstacles, walls)
        for p in nodeslist
            possibleE = LineSegment( Point(p.state), Point(newNode.state))
			if (!algfxn.isCollidingObstacles(possibleE, obstacles) && !algfxn.isCollidingWalls(possibleE, walls)  && 
				p.id != newNode.parentID && min_euclidean(Vec(p.state), Vec(newNode.state)) < connectRadius &&
				(newNode.cost + min_euclidean(Vec(p.state), Vec(newNode.state)) < p.cost))
                ###terriblecode
                # remove edge

				i = findfirst(edgeslist) do y
					y.startID == p.parentID && y.endID == p.id
				end
				
				#@show i
                #@show length(edgeslist)
                if i != 0
                    deleteat!(edgeslist, i)
                end

                p.parentID = newNode.id
                p.cost = newNode.cost + min_euclidean(Vec(p.state), Vec(newNode.state))

                foo = algT.Edge(p.id, newNode.id) 

                # add edge
				push!(edgeslist,foo)
            end
        end
        return nodeslist, edgeslist
    end
    
    #  function findEdge(startID, endID, edgeslist)
                #  #removeID = findEdge(p.startID, p.endID)
        #  for edge in edgeslist 
            #  if edge.startID == startID && edge.endID == endID
                #  return edge
            #  end
        #  end
        #  return 0
    #  end

                    
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

    function steer(fromPt, toPt, connectRadius)
        dist = min_euclidean(Vec(fromPt), Vec(toPt))
        # If pt_rand is too far from its nearest node, "truncate" it to be closer
        if dist <= connectRadius
            return toPt
        else 
            x1,y1 = fromPt
            x2,y2 = toPt

            theta = atan2((y2-y1) , (x2-x1))
            newX = x1 + connectRadius * cos(theta)
            newY = y1 + connectRadius * sin(theta)

            newPt = Point(newX, newY)
            return newPt
        end
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

    #  function findNearestNodes(nodestate, nodeslist, maxDist)
        #  # given maxDist, return all nodes within that distance of node
        #  # list is NOT sorted by distance
        #  nearestNodes = Vector{Tuple{algT.GraphNode, Float64}}()
        #  for n in nodeslist
            #  dist = min_euclidean(Vec(nodestate), Vec(n.state))
            #  if dist < maxDist 
                #  push!(nearestNodes, (n, dist))
            #  end
        #  end
        #  return nearestNodes 
    #  end

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
            if dist <= 3 #HARDCODED REGION #TODO
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
        color := :orange
        linecolor := :black
        #m = (:black, stroke(0))
        s = Shape(xs[:], ys[:])
    end

    @recipe function f(pt::Point)
        xs = [pt[1]]
        ys = [pt[2]]
        seriestype --> :scatter
        color := :orange
        markersize := 3
        xs, ys
    end
    
    @recipe function f(l::LineSegment)
        xs = [ l[1][1], l[2][1] ]
        ys = [ l[1][2], l[2][2] ]
        # seriestype = :line
        color := :darkblue
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

    function plotRoom(room)
        aPlot = plot() #Todo! this assumes plotroom is first thing called()
        roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
        plot!(aPlot, walls, color =:black)
        plot!(aPlot, obstacles, fillalpha=0.5)
        return aPlot
    end

    function plotRRT(roomPlot, graph, solPath, title)
        startstate, goalstate, nodeslist, edgeslist = graph.startstate, graph.goalstate, graph.nodeslist, graph.edgeslist

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

        plot!(roomPlot, edgeXs, edgeYs, color=:tan, linewidth=1)

        rrtPlot = plotSolPath(roomPlot, solPath)
        
        title!(rrtPlot, title)
        plot!(rrtPlot, legend=false, size=(600,600), xaxis=((-2,22), 0:1:20 ), 
              yaxis=((-2,22), 0:1:20), foreground_color_grid= :black, titlefont=font("Arial", 10))


        return rrtPlot
    end

    function plotSolPath(aPlot, solPath)
        #print("\n ---Solution Path----- \n")
        if solPath != Void
            xPath = [n.state[1] for n in solPath] 
            yPath = [n.state[2] for n in solPath]
            xstart, ystart = solPath[1].state

            xend, yend = solPath[end].state
            scatter!(aPlot, [xstart], [ystart], 
                     markercolor= :red, markershape = :circle,  markersize = 6, markerstrokealpha = 0.5, markerstrokewidth=1)
            scatter!(aPlot, [xend], [yend], 
                     markerstrokecolor = :green, markershape = :dtriangle,  markersize = 5, markerstrokealpha = 1, markerstrokewidth=5)
            plot!(aPlot, xPath, yPath, color = :orchid, linewidth=3, fillalpha = 0.3)
        else
           # #print("\n --- No solution path found ----- \n")
        end

        return aPlot
    end


end


# pts are pure Points, nodes have ID information
function rrtPlan(room, parameters, startstate, goalstate, obstaclesList)
    roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
    numPts, connectRadius = parameters.numSamples, parameters.connectRadius

    nodeslist = Vector{algT.TreeNode}()
    edgeslist = Vector{algT.Edge}()

    startNode = algT.TreeNode(); startNode.id = 0; startNode.cost = 0; startNode.state = startstate
    push!(nodeslist, startNode)

    currID = 1 #current node ID

    isPathFound = false

    n_new = algT.TreeNode(); n_new.id = 999999; n_new.state = goalstate; # is this just to initialize? I forgot Todo!

    for i in 1:numPts
        pt_rand = algfxn.sampleFree(roomWidth, roomHeight, obstacles)
        n_nearest = algfxn.nearestN(pt_rand, nodeslist)
        pt_new = algfxn.steer(n_nearest.state, pt_rand, connectRadius) #no node ID yet

        candidateEdge = LineSegment(n_nearest.state, pt_new)
        #newNode = algT.TreeNode(); newNode.state = Point(pt_new);

        if (    !algfxn.isCollidingObstacles(candidateEdge, obstacles) && !algfxn.isCollidingWalls(candidateEdge, walls) )
            n_new = algT.TreeNode(); n_new.id = currID; n_new.state = pt_new
            n_new, nn = algfxn.chooseParent(n_nearest, n_new, nodeslist, connectRadius)
            currID += 1 #we always add nodes, never delete

            newEdge = algT.Edge(n_nearest.id , n_new.id)

            push!(nodeslist, n_new)
            push!(edgeslist, newEdge)
            nodeslist, edgeslist = algfxn.rewire(nodeslist, edgeslist, n_new, connectRadius, obstacles, walls)

            if algfxn.inGoalRegion(pt_new, goalstate)
                #print("\n\n - n_new $n_new , pt_new $pt_new -\n\n")
                isPathFound = true
                #break #TODO
            end
        end
    end

    print("\n\n - pathfound $isPathFound - \n\n")

    pathNodes = Vector{algT.TreeNode}()

    goalnode = algT.TreeNode(); goalnode.id = 999999; goalnode.state = goalstate;
    push!(pathNodes, goalnode)

    if isPathFound
        n_last = n_new
        push!(pathNodes, n_last)

        currPathID = n_last.id

        while currPathID != 0
            foundParent = false

            
            node = startNode;
            for edge in edgeslist
                if edge.endID == currPathID
                    node = algfxn.findNode(edge.startID, nodeslist)
                    push!(pathNodes, node)
                    break
                end
            end
            currPathID = node.id
        end
    else
        # if no feasible path was found, just return the start and end nodes so we can plot them
    end

    push!(pathNodes, startNode)

    finalPathCost = algfxn.costPath(pathNodes) 
    return (nodeslist, edgeslist, isPathFound, pathNodes, finalPathCost)

end

