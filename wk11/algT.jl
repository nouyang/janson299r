module algT
    using GeometryTypes 

    export Node, Edge, Obstacle, Room, AlgParameters, queueTmp, Graph, Pt2D, Line2D, Point

    Pt2D  = Point{2, Float64}
    UNDEF = -999999 #undefined
    Line2D = LineSegment{ Point{2, Float64}}


    struct Node
        id::Int64
        state::Pt2D
        parentID::Int64
        cost::Float64

        Node(id::Int64, state::Pt2D, parentID::Int64 = -999, cost::Float64 = -999.) =
            new(id, state, parentID,  cost)
        end

    struct Edge
        startNode::algT.Node
        endNode::algT.Node
        #  startID::Int64
        #  endID::Int64
        #  startpt::Pt2D
        #  endpt::Pt2D
        #  line::Line2D
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

    struct queueTmp
        node::Node
        statesList::Vector{Node}
        cost::Int64
    end

    struct Graph
        startstate::Pt2D
        goalstate::Pt2D
        nodeslist::Vector{Node}
        edgeslist::Vector{Edge}
    end

    Base.isless(q1::queueTmp, q2::queueTmp) = q1.cost < q2.cost

    import Base.show
    function Base.show(io::IO, n::Node)
        print(io, "($(n.id), $(n.parentID), $(n.state))\n")
    end
    function Base.show(io::IO, e::Edge)
        print(io, "<$(e.startNode.id), $(e.startNode.state); $(e.endNode.id), $(e.endNode.state)>\n")
    end
end

