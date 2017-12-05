module algfxn 
    using GeometryTypes
    using Distributions
    using algT

    function dist(pt1, pt2)
        x2,y2 = pt2[1], pt2[2]
        x1,y1 = pt1[1], pt1[2]
        dist = sqrt( (x1-x2)^2 + (y1-y2)^2 )
        return dist
#        return min_euclidean(Vec(pt1), Vec(pt2))
    end

    function sampleFree(roomW, roomH, obstacles)
        pt_rand = Void
        sampledFree = false
        
        while !sampledFree
            xrand = rand(Uniform(0, roomW))
            yrand = rand(Uniform(0, roomH))
            pt = Point(xrand, yrand)
            if algfxn.isFreeState(pt, obstacles) # this does NOT check if point is on a line (e.g. a wall)
                pt_rand = Point(xrand, yrand) 
                sampledFree = true
            end
        end

        return pt_rand
    end

    function steer(fromPt, toPt, connectRadius)
        @show fromPt
        dist = algfxn.dist(fromPt, toPt)
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


    function isFreeState(node::Point{2, Float64}, obsList::Vector{HyperRectangle})
        for obs in obsList
            if contains(obs, node)
                return false
            end
        end
        return true
    end

    function isFreeMotion(line::LineSegment, obstacles::Vector{HyperRectangle}, walls::Vector{LineSegment})
        return (!algfxn.isCollidingWalls(line, walls) && !algfxn.isCollidingObstacles(line, obstacles))
    end

    #helper1
    function isCollidingObstacles(line::LineSegment, obstacles::Vector{HyperRectangle})
        for obs in obstacles 
            rectLines = decompRect(obs)
            for rectline in rectLines
                if intersects(line, rectline)[1]
                    return true
                end
            end
        end
        return false
    end

    #helper2
    function isCollidingWalls(line::LineSegment, walls::Vector{LineSegment})
        for wall in walls
            if intersects(line, wall)[1]
                return true
            end
        end
        return false
    end

#=     function findNearestNodes(nodestate, nodeslist, maxDist) =#
        #  # given maxDist, return all nodes within that distance of node
        #  # list is NOT sorted by distance
        #  nearestNodes = Vector{Tuple{algT.TreeNode, Float64}}()
        #  for n in nodeslist
            #  dist = algfxn.dist(nodestate, n.state)
            #  if dist < maxDist 
                #  push!(nearestNodes, (n, dist))
            #  end
        #  end
        # return nearest 
    #  end

    function nearestN(pt::Point{2,Float64}, nodeslist)
        # 
        # This loops through all nodes  TODO
        nearestDist = 99999999;
        nearestNode = [];

        for n in nodeslist
            dist = algfxn.dist(pt, n.state)
            if dist < nearestDist
                nearestDist = dist
                nearestNode = n
            end
        end
        #print("$(nearestNode.state), which is type $(typeof(nearestNode)), and from $pt   ")
        return nearestNode
    end

    function inGoalRegion(pt, pt_goal)
        if pt == pt_goal
            return true
        else 
            dist = algfxn.dist(pt, pt_goal)
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
            pathcost += algfxn.dist(curN, prevN)
        end
        return pathcost
    end

    function findNode(nodeID, nodeslist)
        for n in nodeslist
            if n.id == nodeID 
                return n
            end
        end
        #idlist = [node.id for node in nodeslist]
        #index = findfirst(idlist, nodeID)
        #return nodeslist[index]
    end

end

