http://www.glvisualize.com/examples/meshes/


WHELP GLVisualization is used by GeometryTypes documentation. Yay now I've to use both Plots.jl and GLVisualization.jl
 Also yea does Julia still not have multiline comments :/

 http://docs.juliaplots.org/latest/backends/
 http://www.glvisualize.com
 http://www.glvisualize.com/examples/meshes/


julia> Pkg.add("GLVisualize")


Oh what do you know, of course the docs on the github repo would be different and better
https://github.com/JuliaGL/GLVisualize.jl

Seems somewhat supported by plots.jl then


Pkg.test("GLVisualize")


SIGH
ERROR: LoadError: glGenBuffers returned invalid id. OpenGL Context active?




#
closeall()


#
pwd()
cd()
homdir()


#


Yay the backend works.
```
    using Plots
    glvisualize()
    x = 1:10; y = rand(10,2) # 2 columns means two lines
    plot(x,y)
```
whoa and plots.jl makes it magical


okay


ERROR: LoadError: MethodError: no method matching view(::GLAbstraction.Context{GLAbstraction.DeviceUnit}, ::GLWindow.Screen)


Pkg.add("GLAbstraction")

GUH I just needed `_view` instead of `view`

HyperRectangle(Vec3f0(0), Vec3f0(1))
HyperCube(Vec3f0(0), 1f0)


#
oh on pidgin, I just needed to use Buddies > "add chat" instead of "join chat",
then click "open chat on account sign in" and "remain in chat after window
closed"
