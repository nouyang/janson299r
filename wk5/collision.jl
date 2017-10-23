 using GLVisualize, GeometryTypes 
# 
# window = glscreen()
# rectangles = [
# (HyperRectangle(Vec2f0(0), Vec2f0(100)) )
# ]
# 
# view(visualize(rectangles), window)
# 
# renderloop(window)

rect = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))
line = LineSegment(Vec(0., 0), Vec(1., 1))
dist = min_euclidean(line, rect)
print("Dist ", dist)
