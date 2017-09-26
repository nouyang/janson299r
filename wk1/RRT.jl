print("Hello World! ☺ ♫ ☕ \n\n")

using Plots

module rrtTypes
    export Node, Edge, Obstacle, Room, Point

    struct Point
        x::Int
        y::Int
    end

    struct Node
        id::Int
        iPrev::Int #parent
        state::Tuple{Point} 
    end

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

function isCollidingEdge(r, nn, obs)
    # to detect collision, let's just check whether any of the four
    # lines of the rectangular obstacle intersect with our edge
    # ignore collinearity for now

    pt1 = Point(obs.SW.x, obs.SW.y)
    pt2 = Point(obs.SW.x, obs.NE.y)
    pt3 = Point(obs.NE.x, obs.NE.y)
    pt4 = Point(obs.NE.x, obs.SW.y)
    
    # let A, B be r, nn
    coll1 = intersectLineSeg(r, nn, pt1, pt2)
    coll2 = intersectLineSeg(r, nn, pt2, pt3)
    coll3 = intersectLineSeg(r, nn, pt3, pt4)
    coll4 = intersectLineSeg(r, nn, pt4, pt1)

    if (!coll1 && !coll2 && !coll3 && !coll4)
        return false
    end
    return true
end

function inGoalRegion

end

function ccw(A,B,C)
    # determines direction of lines formed by three points
	return (C.y-A.y) * (B.x-A.x) > (B.y-A.y) * (C.x-A.x)
end

function intersectLineSeg(A,B,C,D) #no ":" at the end!
 	return ( (ccw(A, C, D) != ccw(B, C, D)) && ccw(A, B, C) != ccw(A, B, D))
end

function nearestN(r, nodeslist)
    nearestDist = 9999;
    nearestNode = Node;
    for n in nodeslist
        x2,y2 = n.state
        x1,y1 = r
        dist = sqrt( (x1-x2)^2 + (y1-y2)^2 )
        if dist < nearestDist
            nearestDist = dist
            nearestNode = n
        end
    end
    return n
end




function rrtPathPlanner()
    nIter = 10;

    #room = Room(0,0,21,21);

    obs1 = (Point(1,1),Point(5,5))

    rrtstart = Point(1,0)
    goal = Point(18,18)

    nodeslist = Vector{Node}()

    startNode = Node(0,0, rrtstart)
    push!(nodeslist, startNode)
    @printf("string %s",nodeslist)

    maxNodeID = 0
    for i in 1:nIter
        r = Point(rand(1:20),rand(1:20))

        @printf("A random point: %d, %d\n", r.x, r.y)

        if r != obs1  #check node XY first
			nn = nearestN(r, nodeslist)

            if isCollidingEdge(r, nn.state) # check edge
			    continue
			else
                # nodeID, prevNodeId, (x,y)
                node = Node(maxID, nn.id, r)
                #push!(nodeslist, node)
                maxNodeID += 1
                @printf("Found node: %s, %s, %s, %s \n", node.ID, node.prevID, node.state.x, node.state.y)

                if r == goal
                    break
                end
            #    if inGoalRegion(r)
            #        break
            #    end
            end

        end
    end

    return nodeslist
end


rrtPathPlanner()
