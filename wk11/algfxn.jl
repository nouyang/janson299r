module algfxn 
    using GeometryTypes
    using Distributions
    using algT

    function dist(pt1, pt2)
        x2,y2 = pt2[1], pt2[2]
        x1,y1 = pt1[1], pt1[2]
        dist = sqrt( (x1-x2)^2 + (y1-y2)^2 )
        return dist
#        return min_euclidean(pt1), pt2)) #TODO fix this
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
        for n in nodeslist #TODO I reverted back to looping through alll the nodes; fix this
            if n.id == nodeID 
                return n
                break
            end
        end
        #idlist = [node.id for node in nodeslist]
        #index = findfirst(idlist, nodeID)
        #return nodeslist[index]
    end


    ######## RRT* Specific Functions ##########

    function chooseParent(nearestN, newNode,  nodeslist, connectRadius, obstacles, walls)
                        #print("\n --- looking for parent ---\n")
        for n in nodeslist
            pt = n.state
            if ( isFreeMotion( LineSegment(pt, nearestN.state) ,  obstacles, walls) &&
                dist(pt, newNode.state) < connectRadius  && 
                n.cost + dist(pt, newNode.state) < nearestN.cost + dist(nearestN.state, pt)  )

                nearestN = n
            end
        end
        newNode.cost = nearestN.cost + dist(nearestN.state, newNode.state)
        newNode.parentID = nearestN.id
        return newNode, nearestN
    end

    function rewire(nodeslist, edgeslist, newNode, connectRadius, obstacles, walls)
        for j in length(nodeslist)
            p = nodeslist[j]
            newMove = LineSegment( Point(p.state), Point(newNode.state))

            if ( algfxn.isFreeMotion(newMove, obstacles, walls) &&
				p.id != newNode.parentID && dist(p.state, newNode.state) < connectRadius &&
                newNode.cost + dist(p.state, newNode.state) < p.cost )
                ###terriblecode just loops for now
                # remove edge

				#  i = findfirst(edgeslist) do y
                    #  y.startNode.id == p.parentID && y.endNode.id == p.id
				#  end
				

                # print("\n --- REWIRING ---\n")
                for i in length(edgeslist)
                    e = edgeslist[i]
                    if (e.startNode.id == p.parentID && e.endNode.id == p.id)
                        deleteat!(edgeslist, i)
                        # print("\n deletd an edge! $(e) \n")
                        break
                    end

                end


                p.parentID = newNode.id
                p.cost = newNode.cost + dist(p.state, newNode.state)
                nodeslist[i] = p #update node
                foo = algT.Edge(p, newNode) 
                # add back new edge
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
   

    ##################

end

