using Plots, GLVisualize, GeometryTypes 
pyplot()
gui()

@recipe function f(r::HyperRectangle)
    points = decompose(Point{2,Float64}, r)
    rectpoints = points[[1,2,4,3],:]
    xs = [pt[1] for pt in rectpoints];
    ys = [pt[2] for pt in rectpoints];
    seriestype := :shape
	s = Shape(xs[:], ys[:])

end


sizePlot = (400,400)
plot(opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10), foreground_color_grid= :cyan) 

# defined in terms of SW x,y and then w,h
rect1 = HyperRectangle(Vec(1,1), Vec(1.,1))
rect2 = HyperRectangle(Vec(3,3), Vec(1., 2))
rect3 = HyperRectangle(Vec(1,1), Vec(4.,4))
rect4 = HyperRectangle(Vec(3,3), Vec(4.,4))
rect5 = HyperRectangle(Vec(2,2), Vec(1.,1))

a = LineSegment(Point2f0(0,0), Point2f0(1,0))

n = rand(1:100)
footitle = "update check: $n"
fig = plot(opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10), foreground_color_grid= :lightgray, title=footitle)

# opacity

#a = minmax_euclidean(rect1, rect2)
#b = minmax_euclidean(rect2, rect3)
#c = overlaps(rect1, rect2)
#d = overlaps(rect2, rect3)

print("test $a \n $b \n $c \n $d \n ")


#contains(rect3, rect1)
#in(rect3, rect5)
#overlaps(rect3, rect4)

# works for points (but overlaps not defined)
# p = Point(1,1)

plot!(rect1,opacity=0.2)
plot!(rect2,opacity=0.2)
plot!(rect3,opacity=0.2)
plot!(rect4,opacity=0.2)
plot!(rect5,opacity=0.2)
plot!(a)


s = Shape([0,2,3,0],[0,0,3,4])
#plot!(s)

#dist = min_euclidean(rect1, rect2)
#print("Dist $dist")
#x = 1:10; y = rand(10,2) # 2 columns means two lines
#plot(x,y)

