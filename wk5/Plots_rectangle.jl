using Plots
using GeometryTypes
gr() 

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
    rectpoints = points[[1,2,4,3,1],:]
    #SW = points[1]
    #NE = points[4]
    xs = [pt[1] for pt in rectpoints]
    ys = [pt[2] for pt in rectpoints]
    seriestype := :shape
    xs, ys #this is what we are returning
end
#rectangle(w, h, x, y) = Shape(x + [0,w,w,0], y + [0,0,h,h])



sizePlot = (400,400)
myrect = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))
plot(myrect, legend=false, size=sizePlot, yaxis=((0,10), 0:1:10), xaxis=((0,10), 0:1:10))
