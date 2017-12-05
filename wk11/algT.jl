module algT
    using GeometryTypes 

    export Node, Edge, Obstacle, Room, AlgParameters, queueTmp, Graph

    Pt2D  = Point{2, Float64}
    UNDEF = -999999 #undefined
    Line2D = LineSegment{ Pt2D}

    struct Node
        id::Int64
        parentID::Int64
        state::Pt2D
        cost::Float64
        Node(id::Int64, state::Pt2D) = new(id, UNDEF, state, UNDEF) #todo do this with outer constructors?
        Node(id::Int64, parentID::Int64, state::Pt2D) = new(id, parentID, state, UNDEF)
        Node(id::Int64, parentID::Int64, state::Pt2D, cost::Float64) = new()
	end

    struct Edge
        startID::Int64
        endID::Int64
        startpt::Pt2D{T}
        endpt::Pt2D{T}
        line::Line2D{T}
        Edge( startID::Int64, endID::Int64) = new(startID, endID, UNDEF, UNDEF, UNDEF)
        Edge( startID::Int64, endID::Int64) = new(startID, endID, UNDEF, UNDEF, UNDEF)
        Edge( startpt::Pt2D{T}, endpt::Pt2D{T}) = new( UNDEF, UNDEF, startpt, endpt, UNDEF)
        Edge( startID::Int64, endID::Int64, startpt::Pt2D{T}, endpt::Pt2D{T}) = Edge( startID, endID, startpt, endpt, UNDEF)
        Edge( line::Line2D{T} ) = Edge( UNDEF,UNDEF,UNDEF,UNDEF, line)
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
        startstate::Pt2D{T}
        goalstate::Pt2d{T}
        nodeslist::Vector{Node}
        edgeslist::Vector{Edge}
    end

    Base.isless(q1::queueTmp, q2::queueTmp) = q1.cost < q2.cost

end

