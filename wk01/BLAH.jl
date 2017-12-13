

module rrtTypes
    export Node, Edge, Obstacle, Room, Point

    struct Point
        x::Int
        y::Int
    end

    struct Node
        id::Int
        iPrev::Int #parent
        state::Tuple{Point} #hrm, don't know how to restrict to two points.  i guess it's immutable so use tuple
    end
    Base.start(n::Node) = 1
    Base.done(n::Node, i) = nfields(n) < i
    Base.next(n::Node, i) = getfield(n, i), i+1

    struct Edge
        startnode::Int
        endnode::Int
    end

    struct Obstacle
        SW
        NE
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
            
end
