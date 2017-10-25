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
        obstacles::Vector{Obstacle}
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


    function findNearestNodes(node, nodeslist, maxDist)
        # given maxDist, return all nodes within that distance of node
        nearestNodes = Vector{Point}()
        for n in nodeslist
            dist = norm(node.state - n.state)
            if dist < maxDist 
                push!(nearestNodes, n)
            end
        end
        return nearestNodes 
    end

    function findNodeFromState(nodeState, nodeslist)
        node = Void
        for n in nodeslist
            if n.state == nodestate
                return n
            end
        end
    end

end

function preprocessPRM(room, parameters) 
    roomWidth, roomHeight, walls, obstacles = room
    numPts, connectRadius = parameters

    nodeslist = Vector{alg.GraphNode}()
    edgeslist = Vector{alg.Edge}()

    currID = 1

    # Sample points, create list of nodes 
    for i in 1:numPts
        n = Point(rand(roomWidth),rand(roomHeight)) #new point in room
        if !algfxn.isCollidingNode(n, obstacles) #todo
            newNode = alg.GraphNode(maxID, n)
            maxID += 1
            push!(nodeslist, newNode)
        end
    end

    # Connect each node to its neighboring nodes within a ball or radius r, creating edges
    for startnode in nodeslist 
        neighbors = findNearestNodes(startnode, nodeslist, connectRadius) # parent point #TODO
        for endnode in neighbors
            if !isCollidingEdge(startnode, endnode, obstacles) #todo
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




function main()
    print("Hi")


    ## Definte room
    obs1 = HyperRectangle(Vec(8,3), Vec(2,15)) #Todo
    obstacles = Vector{HyperRectangle}()
    push!(obstacles, obs1)

    w,h  = 21,21
    walls = HyperRectangle( Vec(0,0), Vec(l,w))

    r = Room(w,h,walls,obstacles)
    numSamples = 10
    connectRadius = 10
    param = alg.AlgParameters(10,10)

    ## Run preprocessing
    preprocessPRM(r, param)

    ## Plot preprocessing results

####
startGoal = alg.GraphNode(0, Point(0,0))
endNode = alg.GraphNode(0, Point(0,0))

end

main()
