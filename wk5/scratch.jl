print("Hi!")
module tmp
    using GeometryTypes
    struct Node2
        id::Int
        iPrev::Int #parent
        state::Point2f0
    end

    Node2(id::Int, iPrev::Int) = Node2(id, iPrev, Point(2,2))
end

    x = tmp.Node2(1,2,Point(2,3))
    y = tmp.Node2(1,2)
