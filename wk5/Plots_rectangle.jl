using Plots
using GeometryTypes
gr()t 
plot()

### SANITY CHECK
x = 1:10; y = rand(10,2) # 2 columns means two lines
plot(x,y)

#rect = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))

#module foo 
#    struct Rect
#        NE::GeometryTypes.Point2f0
#        SW::GeometryTypes.Point2f0
#    end
#end


@recipe function f(r::HyperRectangle)
    points = decompose(Point{2,Float64}, r)
    rectpoints = points[[1,2,4,3],:]
    xs = [pt[1] for pt in rectpoints];
    ys = [pt[2] for pt in rectpoints];
    seriestype := :shape
	s = Shape(xs[:], ys[:])
end
sizePlot = (400,400)
r = HyperRectangle(Vec(1,1), Vec(2,4))
fig = plot(opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10)) 
plot(r, opacity=0.5, legend=false, size=sizePlot, yaxis=( (0,10), 0:1:10), xaxis=( (0,10), 0:1:10)) 
plot!(r)
