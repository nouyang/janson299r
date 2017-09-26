print("Hello World! ☺ ♫ ☕ \n\n")

using Plots
gr()

plot([1,2],[2,3])

module rrt 
    export Node, Edge, Obstacle, Room, Point

    struct Point
        x::Int
        y::Int
    end

    struct Node
        id::Int
        iPrev::Int #parent
        state::Point
    end

    struct Edge
        startnode::Int
        endnode::Int
    end

    struct Obstacle
        SW::Point
        NE::Point
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

    pt1 = rrt.Point(obs.SW.x, obs.SW.y)
    pt2 = rrt.Point(obs.SW.x, obs.NE.y)
    pt3 = rrt.Point(obs.NE.x, obs.NE.y)
    pt4 = rrt.Point(obs.NE.x, obs.SW.y)
    
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
    nearestNode = []; #I guess we can use this to delcare an empty any type?
    for n in nodeslist
        x2,y2 = n.state.x, n.state.y
        x1,y1 = r.x, r.y
        dist = sqrt( (x1-x2)^2 + (y1-y2)^2 )
        if dist < nearestDist
            nearestDist = dist
            nearestNode = n
        end
    end
    #@show nearestNode

    return nearestNode
end




function rrtPathPlanner()
    h = plot([1,2],[2,3])
    nIter = 10;
    #room = Room(0,0,21,21);

    obs1 = rrt.Obstacle(rrt.Point(2,2),rrt.Point(5,5))

    rrtstart = rrt.Point(1,0)
    goal = rrt.Point(18,18)

    nodeslist = Vector{rrt.Node}()
    #nodeslist = []

    startNode = rrt.Node(0,0, rrtstart)
    push!(nodeslist, startNode)
    #@printf("string %s",nodeslist)

    maxNodeID = 1
    for i in 1:nIter
        #@show i
        r = rrt.Point(rand(1:20),rand(1:20))


        if r != obs1  #check node XY first
			nn = nearestN(r, nodeslist)

            if isCollidingEdge(r, nn.state, obs1) # check edge
                @printf("Cancelling due to collision %d\n", i)
			    continue
			else
                # nodeID, prevNodeId, (x,y)
                node = rrt.Node(maxNodeID, nn.id, r)
                push!(nodeslist, node)
                maxNodeID += 1
                #@printf("Found node: %s, %s, %s, %s \n", node.id, node.iPrev, node.state.x, node.state.y)

                if r == goal
                    print("Goallllll!")
                #    @show nodeslist
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


nlist = rrtPathPlanner()

function plotPath(nlist)

    ### <COPIED FOR NOW
    obs1 = rrt.Obstacle(rrt.Point(2,2),rrt.Point(5,5))

    rrtstart = rrt.Point(1,0)
    goal = rrt.Point(18,18)
    ### / COPIED FOR NOW>


    foo = rand(1)
    h = plot()
    @printf("%s", "plotted\n")
    plot!(h, legend=false, size=(600,600),xaxis=((-5,25), 0:1:20 ), yaxis=((-5,25), 0:1:20), foreground_color_grid=:lightcyan)
    title!("A rrt visualization $(foo)")

    # plot room
    dim = 21 
    roomx = [0,0,dim,dim];
    roomy = [0,dim,dim,0];
    plot!(roomx, roomy, color=:black, linewidth=5)

    # plot start and end goals
    circle(1,0, 0.5, :red)
    circle(18,18, 0.5, :forestgreen)

    # plot obstacles
    obs1 = rrt.Obstacle(rrt.Point(1,1),rrt.Point(5,5))
    circleObs(obs1)

    plotEdge(nlist[3], nlist)
    # plot all paths
     for n in nlist
         @show n
        # plotEdge(n, nlist)
     end


    # plot winning path
    # display winning path cost
end

#module pHelp()

    ### Some helper functions
    function circle(x,y,r,c_color)
        th = 0:pi/50:2*pi;
        xunit = r * cos.(th) + x;
        yunit = r * sin.(th) + y;
        plot!(xunit, yunit,color=c_color,linewidth=3.0);
    end

    function circleObs(obstacle)
        x1,y1 = obstacle.SW.x, obstacle.SW.y
        x2,y2 = obstacle.NE.x, obstacle.NE.y
        r = 0.2
        obsColor = :blue

        circle(x1,y1,r,obsColor)
        circle(x1,y2,r,obsColor)
        circle(x2,y1,r,obsColor)
        circle(x2,y2,r,obsColor)

        plot!([x1,x1,x2,x2,x1], [y1,y2,y2,y1,y1], color=obsColor, linewidth=2)
    end

    function plotEdge(node, nlist)
        if node.id == 0
            return
        end
        pt1 = node.state
        iPrev = node.iPrev
        nPrev = findNode(iPrev, nlist) 
        pt2 = nPrev.state
        plot!( [pt1.x, pt2.x],[pt1.y, pt2.y], color=:orange, linewidth=3)
    end

    function findNode(id, nodeslist)
        for n in nodeslist
            if n.id == id
                return n
            end
        end
    end
#end

plotPath(nlist)
