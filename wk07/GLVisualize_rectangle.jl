using GLVisualize, GeometryTypes, GLAbstraction

window = glscreen()

rectangles = HyperRectangle(Vec2f0(0), Vec2f0(100)) 
rectangles = [  HyperRectangle(Vec2f0(0), Vec2f0(100)), 
                HyperRectangle(Vec2f0(100), Vec2f0(200)) ]

_view(visualize(rectangles), window)
#_view(visualize(rectangles), window)

renderloop(window)

#http://www.glvisualize.com/examples/sprites/#bouncy
