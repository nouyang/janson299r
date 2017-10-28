####################################################

#  This file is used for development and testing of PRM.jl. 
#  It runs the PRM once and plots the results.
#  nouyang 2017

####################################################
# MAIN
####################################################
include("PRM.jl")

function main()
    numSamples = 25
    connectRadius =10 
    param = algT.AlgParameters(numSamples, connectRadius)

    print("\n ---- Running PRM ------ \n")
    ## Define obstacles
    obs1 = HyperRectangle(Vec(8,3.), Vec(2,2.)) #Todo
    obs2 = HyperRectangle(Vec(4,4.), Vec(2,10.)) #Todo

    obstacles = Vector{HyperRectangle}()
    push!(obstacles, obs1, obs2)

    # Define walls
    walls = Vector{LineSegment}()
    w,h  = 20,20
    perimeter = HyperRectangle(Vec(0.,0), Vec(w,h))
    roomPerimeter = algfxn.decompRect(perimeter)
    #internalwalls =  (linesegs
    for l in roomPerimeter
        push!(walls, l)
    end

    r = algT.Room(w,h,walls,obstacles)
    plotfxn.plotRoom(r)

    ## Run preprocessing
    nodeslist, edgeslist = preprocessPRM(r, param)

    ## Query created RM
    startstate = Point(1.,1)
    goalstate = Point(18.,18)

    pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)

    ## Plot path found
    title = "PRM with # samples =$numSamples, \nPathfound = $isPathFound, \npathcost = $pathcost"
    roadmap = algT.roadmap(startstate, goalstate, nodeslist, edgeslist)

    plot = plotfxn.plotPRM(roadmap, solPath, title::String)

####
#startGoal = algT.GraphNode(0, Point(0,0))
#endNode = algT.GraphNode(0, Point(0,0))

end


function collTest()

####
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


    function isCollidingEdge(line::LineSegment, obsList::Vector{HyperRectangle})

        print("\n -------- \n")
		@show line 
        print("\n -------- \n")
        for obs in obsList
            rectLines = decompRect(obs)
            for rectline in rectLines
                @show intersects(line, rectline)[1]
				@show rectline
        print("\n -------- \n")
                if intersects(line, rectline)[1]
                    return true
                end
            end
        end
        return false
    end

function ccw(A,B,C)
    # determines direction of lines formed by three points
	return (C[2]-A[2]) * (B[1]-A[1]) > (B[2]-A[2]) * (C[1]-A[1])
	#return (C.y-A.y) * (B.x-A.x) > (B.y-A.y) * (C.x-A.x)
end


function intersectLineSeg(line1, line2) #no ":" at the end!
	A, B = line1[1], line1[2]
	C, D = line2[1], line2[2]
 	return ( (ccw(A, C, D) != ccw(B, C, D)) && ccw(A, B, C) != ccw(A, B, D))
end
####
	#obs1 = GeometryTypes.HyperRectangle{2,Float64}([7.67199, 10.8904], [1.67166, 2.51185])
	obs1 = GeometryTypes.HyperRectangle{2,Float64}([7,10], [2,3])

    obstacles = Vector{HyperRectangle}()
    push!(obstacles, obs1)

	#nodeslist = algT.GraphNode[algT.GraphNode(1, [18.7716, 16.8013]), algT.GraphNode(2, [12.8554, 11.3548]), algT.GraphNode(3, [13.4626, 13.6564]), algT.GraphNode(4, [14.5381, 7.52624]), algT.GraphNode(5, [15.5076, 17.8328]), algT.GraphNode(6, [4.65531, 14.1306]), algT.GraphNode(7, [15.3949, 17.6171]), algT.GraphNode(8, [1.34579, 4.52833]), algT.GraphNode(9, [15.2216, 11.153]), algT.GraphNode(10, [6.29213, 11.7306])]

    #anEdge = algT.Edge(2, 10)

	#startnode = nodeslist[2]
	startnode = algT.GraphNode(1, [6,11])
	#endnode = nodeslist[10]
	endnode = algT.GraphNode(2, [12,11])

	l = LineSegment(Point(6.0,11), Point(12.0,11))

    coll = isCollidingEdge(l, obstacles)
    @show coll
    #isCollidingNode

#(intersects(line, rectline))[1] = true
#r1 = GeometryTypes.Point{2,Float64}[[9.0, 10.0], [9.0, 13.0]]
r1 =LineSegment( Point(9.0,10.0), Point(9.0, 13.0))


 #-------- 
#(intersects(line, rectline))[1] = false
#r2 = GeometryTypes.Point{2,Float64}[[9.34365, 10.8904], [9.34365, 13.4022]]
r2 =LineSegment( Point(9.34365, 10.890), Point(9.34365, 13.402))

@show f= intersects(l, r1)
@show intersects(l, r2)
@show intersectLineSeg(l, r1)
@show intersectLineSeg(l, r2)

#https://github.com/JuliaGeometry/GeometryTypes.jl/blob/master/src/lines.jl

end


########################################
# Call main() function
########################################   

main()
#collTest()

# 
 # EDGE REMOVED: algT.GraphNode(3, [13.4626, 13.6564]) WITH algT.GraphNode(10, [6.29213, 11.7306])  
 # EDGE REMOVED: algT.GraphNode(9, [15.2216, 11.153]) WITH algT.GraphNode(10, [6.29213, 11.7306])  
 # EDGE REMOVED: algT.GraphNode(10, [6.29213, 11.7306]) WITH algT.GraphNode(3, [13.4626, 13.6564])  
 # EDGE REMOVED: algT.GraphNode(10, [6.29213, 11.7306]) WITH algT.GraphNode(9, [15.2216, 11.153])  
 # ---- pre-processed --- 
 # ---- queried ---- 
 # ---Solution Path----- 
# solPath = algT.GraphNode[algT.GraphNode(0, [1.0, 1.0]), algT.GraphNode(8, [1.34579, 4.52833]), algT.GraphNode(10, [6.29213, 11.7306]), algT.GraphNode(2, [12.8554, 11.3548]), algT.GraphNode(1, [18.7716, 16.8013]), algT.GraphNode(0, [18.0, 18.0])]
 # -------- 
 # --- Time --- 
# timestamp = 2017-10-28T03:19:26.972
 # --- Obstacles --- 
# obstacles = GeometryTypes.HyperRectangle[GeometryTypes.HyperRectangle{2,Float64}([7.67199, 10.8904], [1.67166, 2.51185]), GeometryTypes.HyperRectangle{2,Float64}([1.27599, 14.9952], [1.25427, 3.5936]), GeometryTypes.HyperRectangle{2,Float64}([4.64947, 3.96388], [8.07466, 4.21098])]
 # --- Nodes --- 
# nodeslist = algT.GraphNode[algT.GraphNode(1, [18.7716, 16.8013]), algT.GraphNode(2, [12.8554, 11.3548]), algT.GraphNode(3, [13.4626, 13.6564]), algT.GraphNode(4, [14.5381, 7.52624]), algT.GraphNode(5, [15.5076, 17.8328]), algT.GraphNode(6, [4.65531, 14.1306]), algT.GraphNode(7, [15.3949, 17.6171]), algT.GraphNode(8, [1.34579, 4.52833]), algT.GraphNode(9, [15.2216, 11.153]), algT.GraphNode(10, [6.29213, 11.7306])]
# 
 # --- Edges --- 
# edgeslist = algT.Edge[algT.Edge(1, 1), algT.Edge(1, 2), algT.Edge(1, 3), algT.Edge(1, 5), algT.Edge(1, 7), algT.Edge(1, 9), algT.Edge(2, 1), algT.Edge(2, 2), algT.Edge(2, 3), algT.Edge(2, 4), algT.Edge(2, 5), algT.Edge(2, 6), algT.Edge(2, 7), algT.Edge(2, 9), algT.Edge(2, 10), algT.Edge(3, 1), algT.Edge(3, 2), algT.Edge(3, 3), algT.Edge(3, 4), algT.Edge(3, 5), algT.Edge(3, 6), algT.Edge(3, 7), algT.Edge(3, 9), algT.Edge(4, 2), algT.Edge(4, 3), algT.Edge(4, 4), algT.Edge(4, 9), algT.Edge(4, 10), algT.Edge(5, 1), algT.Edge(5, 2), algT.Edge(5, 3), algT.Edge(5, 5), algT.Edge(5, 7), algT.Edge(5, 9), algT.Edge(6, 2), algT.Edge(6, 3), algT.Edge(6, 6), algT.Edge(6, 10), algT.Edge(7, 1), algT.Edge(7, 2), algT.Edge(7, 3), algT.Edge(7, 5), algT.Edge(7, 7), algT.Edge(7, 9), algT.Edge(8, 8), algT.Edge(8, 10), algT.Edge(9, 1), algT.Edge(9, 2), algT.Edge(9, 3), algT.Edge(9, 4), algT.Edge(9, 5), algT.Edge(9, 7), algT.Edge(9, 9), algT.Edge(10, 2), algT.Edge(10, 4), algT.Edge(10, 6), algT.Edge(10, 8), algT.Edge(10, 10)]
