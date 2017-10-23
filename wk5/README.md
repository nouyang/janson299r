http://www.glvisualize.com/examples/meshes/


WHELP GLVisualization is used by GeometryTypes documentation. Yay now I've to use both Plots.jl and GLVisualization.jl
 Also yea does Julia still not have multiline comments :/

 http://docs.juliaplots.org/latest/backends/
 http://www.glvisualize.com
 http://www.glvisualize.com/ete string and in
 Gxamples/meshes/


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

## 
trying to plot multiple rectangles....

```

using GLVisualize, GeometryTypes, GLAbstraction
window = glscreen()
rectangles = [  HyperRectangle(Vec2f0(0), Vec2f0(100)), 
                HyperRectangle(Vec2f0(100), Vec2f0(200)) ]

_view(visualize(rectangles), window)
renderloop(window)

```

`ERROR: LoadError: MethodError: no method matching _default(::Array{GeometryTypes.HyperRectangle{2,Float32},1}, ::GLAbstraction.Style{:default}, ::Dict{Symbol,Any})`


##

multiple rectangles, go back to @recipe....


#

oh on pidgin, I just needed to use Buddies > "add chat" instead of "join chat",
then click "open chat on account sign in" and "remain in chat after window
closed"

`#julia` on irc.freenode.net


gitter.im/tbreloff/Plots.jl
https://gitter.im/JuliaLang/julia


https://github.com/JuliaGeometry/GeometryTypes.jl
-> examples use GLVisualize


Ok investiage GLVisualize
http://www.glvisualize.com/examples/meshes/#meshcreation
https://gist.github.com/SimonDanisch/09bd66aa2764aecf84e5da1dd986d62d#file-image_hover-jl


#

https://github.com/JuliaGeometry/GeometryTypes.jl/blob/7bf380a0d6aa8a4249606b6e0987ce4149788cbb/test/hypersphere.jl
apparently  f0 = float32
 Vec3f0(0.5f0)
 Yeah, 3f0 means 3 float32s

 
#

```
plotting a geometryTypes rectangle

julia> b = HyperRectangle(Vec(1,1),Vec(2,2))
julia> decompose(Point{2,Int},b)
4-element Array{GeometryTypes.Point{2,Int64},1}:
 [1, 1]
 [3, 1]
 [1, 3]
 [3, 3]
```

#

```
@recipe function f(a::Vector{<:MockRectangle})
    for i in a
       @series begin
          i
       end
    end
end
```

#
ERROR: LoadError: InexactError()

because
used Int instead of Float64

    points = decompose(Point{2,Float64}, r)

#
ERROR: LoadError: DimensionMismatch("dimensions must match")

What is difference between Array{Float64,2} and Array{Float64,1} and how to I drop from 2 to 1??

julia> s = Shape(xs, ys)
ERROR: MethodError: Cannot `convert` an object of type Array{Float64,2} to an object of type Array{Float64,1}
This may have arisen from a call to the constructor Array{Float64,1}(...),
since type constructors fall back to convert methods.
Stacktrace:
 [1] Plots.Shape(::Array{Float64,2}, ::Array{Float64,2}) at /home/nrw/.julia/v0.6/Plots/src/components.jl:15

julia> Shape([1,1,1,1], [2,2,2,2])
Plots.Shape([1.0, 1.0, 1.0, 1.0], [2.0, 2.0, 2.0, 2.0])

julia> xs
4×1 Array{Float64,2}:

julia> [1,1,1,1] #column!
4-element Array{Int64,1}:

julia> [1;1;1;1]
4-element Array{Int64,1}:

julia> [1 1 1 1 ]
1×4 Array{Int64,2}:

### Found it!
xs[:]'


https://discourse.julialang.org/t/how-to-draw-a-rectangular-region-with-plots-jl/1719/3

## accessing matrix rows out of order

since otherwise, we draw some weird halved diamond, instead of a rectangle

julia> f[[1,2,4,3],:]

returns a matrix containing the 1st, 2nd, 4th, and then 3rd rows on the original matrix

# GR
sigh
GR cannot resize windows: known GR issue
GR occasionally has a frozen window, that can't be closed unless one closes julia: known GR issue


# versions
Pkg.status("Plots")



# clear all
workspacE()G

# randint
rand(1:10)

# print variables
bar = 123
print("test: $bar")



##
opacity does not work on gr() 


##
guhhhhhhhhhhhhhhhhhhhhhhhhhhhhh why did I do all this work. I could just use
Shape(). Oh, well, I learned a lot I guess, and it could come in handy in the
future. Maybe.

