using GeometryTypes
using GLVisualize

rect = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))
line = LineSegment(Vec(0., 0), Vec(1., 1))
min_euclidean(line, rect)

testRectViz = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))


view(visualize(testRectViz), window)

renderloop(window)


