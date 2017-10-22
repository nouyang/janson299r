using GeometryTypes
using GLVisualize
window = glscreen()

rect = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))
line = LineSegment(Vec(0., 0), Vec(1., 1))
min_euclidean(line, rect)

testRectViz = HyperRectangle(Vec(0.5, 0.5), Vec(1., 1))


view(visualize(testRectViz), window)

renderloop(window)

#primitive = SimpleRectangle(0f0,-0.5f0,1f0,1f0)





#view(bars, window, camera=:orthographic_pixel)

