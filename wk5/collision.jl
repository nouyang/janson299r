using Plots, GeometryTypes 



@recipe function f(r::HyperRectangle)
    points = decompose(Point{2,Float64}, r)
    rectpoints = points[[1,2,4,3],:]
    xs = [pt[1] for pt in rectpoints];
    ys = [pt[2] for pt in rectpoints];
    seriestype := :shape
    color = :orange
	#m = (:black, stroke(0))
	s = Shape(xs[:], ys[:])
end

@recipe function f(pt::Point)
    xs = [pt[1]]
    ys = [pt[2]]
    seriestype --> :scatter
    color := :orange
    markersize := 6
    xs, ys
end
 
@recipe function f(l::LineSegment)
    xs = [ l[1][1], l[2][1] ]
    ys = [ l[1][2], l[2][2] ]
    # seriestype = :line
    color = :red
    lw := 3
    xs, ys
end


@recipe function f(rectList::Vector{<:HyperRectangle})
    for r in rectList
	  @series begin
         r 
	  end
   end
end

@recipe function f(ptList::Vector{<:Point})
    for p in ptList
	  @series begin
         p
	  end
   end
end

@recipe function f(lineList::Vector{<:LineSegment})
    for l in lineList 
	  @series begin
         l 
	  end
   end
end
sizePlot = (400,400)
plot(opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10), foreground_color_grid= :cyan) 
 
# defined in terms of SW x,y and then w,h
rect1 = HyperRectangle(Vec(1,1), Vec(1.,1))
rect2 = HyperRectangle(Vec(3,3), Vec(1., 2))
rect3 = HyperRectangle(Vec(1,1), Vec(4.,4))
rect4 = HyperRectangle(Vec(3,3), Vec(4.,4))
rect5 = HyperRectangle(Vec(2,2), Vec(1.,1))

vecR = Vector{HyperRectangle}()
push!(vecR,rect1, rect2, rect3, rect4, rect5)

vecPt = Vector{Point{2, Float64}}()


##########TEST POINTS################
nl = LineSegment(Point(6,8), Point(-1,0))
np = Point(6,8) # This doesnt work with plot (error,ERROR: LoadError: No user recipe defined for Float32)
mp = Point(8,8)
zp = Point(1,1)
xp = Point(3,3)
#mp = Point(9,9)


push!(vecPt, mp, zp, np, xp)

n = rand(1:100)
footitle = "update check: $n"
plot(opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10), foreground_color_grid= :lightgray, title=footitle)

# opacity

a = minmax_euclidean(rect1, rect2)
b = minmax_euclidean(rect2, rect3)
c = overlaps(rect1, rect2)
d = overlaps(rect2, rect3)

print("test $a \n $b \n $c \n $d \n ")


e = contains(rect3, rect1) #rect 1 is tentirely inside rect 3
i = overlaps(rect3, rect1) #rect 1 is tentirely inside rect 3
h = in(rect3, rect1) #rect 1 is tentirely inside rect 3
f = in(rect3, rect5) #rect 3 and 5 do not overlap at all
g = overlaps(rect3, rect4) #rec 3 and 4 definitely overlap
print("test $e, $i, $h, $f, $g")

#ashape = Shape([0,2,3,0],[0,0,3,4])
gui()


# Check collision of node and rectangle
# works for points (but overlaps not defined)
# p = Point(1,1)
gp = in(rect3, zp) #rec 3 and 4 definitely overlap

###############TEST LINES#################
# Check collision of edge and rectangle
aline = LineSegment(np, mp) #horz at top, line in middle of nowhere
bline = LineSegment(zp,xp) #short diagonal
cline = LineSegment(zp,np) #long diagonal

vecLine = Vector{LineSegment}()
push!(vecLine, aline, bline, cline)

stmt = (rect1, bline)
a = minmax_euclidean(rect1, rect2)
b = minmax_euclidean(rect2, rect3)
c = overlaps(rect1, rect2)
d = overlaps(rect2, rect3)


## Bline: collides with 2,4,5, but not 1 and 3?

#print("\nAre the rectangle and line colliding? $stmt")


# aline shouldn't collide with anything
# bline should collide with rect4, rect5,
# cline should collide with rect4, but not rect1


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

oppa = 0.5
plot!(vecR, opacity=oppa)
plot!(mp, seriestype=:scatter, markersize=3, color=:blue)
plot!(vecPt)
plot!(vecLine)

lines = decompRect(rect1);

# test an edge now.

# let's assume nodes not in rectangle for now -- or double-check again, just in case?
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


#testE = LineSegment(Point(1.,0), Point(1.,10)) #collinear seems to collide correctly!
testE = LineSegment(Point(0.,0), Point(1.,2)) 
iscol = isCollidingEdge(testE, vecR) 
print("\nAre the rectangles and line colliding? $iscol\n")

plot!(lines)

testl = LineSegment(Point(0.,0), Point(5.,5)) #remember to use period for float64 instead of int64
testl2 = LineSegment(Point(1.,1), Point(3.,3))
testl3 = LineSegment(Point(1.,3), Point(3.,1))
plot!(testE, color=:red)
plot!(testl)
plot!(testl2)
plot!(testl3)






#TODO: test for collinear lines....





# treeNode
# id
# prevID #either that, or store edges? 
# state
# 
# graphNode
# id
# state
# 
# 
# Edge
# linsegement
# startid
# endied
# 
# function isCollidingNode(n::GraphNode, obsList::Vector{HyperRectangle})
    # for rect in obsList
        # if in(rect, n.state)
            # return true
        # end
    # end
    # return false
# end
# 
# function isCollidingEdge(e::Edge, obsList::Vector{HyperRectangle})
    # for rect in obsList
        # if overlaps
# 
#plot!(s)

#dist = min_euclidean(rect1, rect2)
#print("Dist $dist")
#x = 1:10; y = rand(10,2) # 2 columns means two lines
#plot(x,y)
