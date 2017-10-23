using Plots, GLVisualize, GeometryTypes 
gr()
#glvisualize()

@recipe function f(r::HyperRectangle)
    points = decompose(Point{2,Float64}, r)
    rectpoints = points[[1,2,4,3],:]
    xs = [pt[1] for pt in rectpoints];
    ys = [pt[2] for pt in rectpoints];
    seriestype := :shape
	s = Shape(xs[:], ys[:])
end


sizePlot = (400,400)
#r = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))
#plot!(r, opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10)) 
plot(opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10), foreground_color_grid= :cyan) 

# defined in terms of SW x,y and then w,h
rect1 = HyperRectangle(Vec(1,1), Vec(0.5, 0.5))
rect2 = HyperRectangle(Vec(3,3), Vec(1., 2))


n = rand(1:100)
footitle = "update check: $n"
fig = plot(legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10), foreground_color_grid= :lightgray, title=footitle)

plot!(rect1)
plot!(rect2)

#overlaps(rect1, rect2)

#dist = min_euclidean(rect1, rect2)
#print("Dist ", dist)
#x = 1:10; y = rand(10,2) # 2 columns means two lines
#plot(x,y)

