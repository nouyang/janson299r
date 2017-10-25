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


# Pkg.update()

WARNING: Package SFML: skipping update (dirty)...

Pkg.add("GR")
Pkg.build("GR")
ERROR: LoadError: InitError: UndefRefError: access to undefined reference




Guh why did I update. :(


julia> Pkg.rm("GR")


========================================================[ ERROR: Ipopt ]=========================================================

LoadError: failed process: Process(`../configure --prefix=/home/nrw/.julia/v0.6/Ipopt/deps/usr --disable-shared --with-pic`, ProcessExited(1)) [1]
while loading /home/nrw/.julia/v0.6/Ipopt/deps/build.jl, in expression starting on line 89

=================================================================================================================================

========================================================[ BUILD ERRORS ]=========================================================

WARNING: Ipopt had build errors.

 - packages with build errors remain installed in /home/nrw/.julia/v0.6
 - build the package(s) and all dependencies with `Pkg.build("Ipopt")`
 - build a single package by running its `deps/build.jl` script

=====================================


nrw@chai:~/.julia/v0.6/GR/deps((no branch))$ julia
julia> include("./build.jl")


julia> using GR
ERROR: InitError: UndefRefError: access to undefined reference

WELL THEN. oh god I hate Julia so much right now. I've spent 10 hours trying to plot TWO REcTANGLES. guhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh

Well. I'll just drop in glvisualize() instead of gr() everywhere then.


# Reinstall Julia

sudo apt-get dist-upgrade julia



Deleted .tar.gz folder extract.
Deleted contents of .julia folder.
nrw@chai:~$ sudo apt-get remove julia
```
nrw@chai:/usr/local/bin$ julia
ERROR: LoadError: ArgumentError: Module IJulia not found in current path.
Run `Pkg.add("IJulia")` to install the IJulia package.
Stacktrace:
 [1] _require(::Symbol) at ./loading.jl:428
 [2] require(::Symbol) at ./loading.jl:398
 [3] include_from_node1(::String) at ./loading.jl:569
 [4] include(::String) at ./sysimg.jl:14
 [5] try_include at ./client.jl:244 [inlined]
 [6] load_juliarc() at ./client.jl:321
 [7] process_options(::Base.JLOptions) at ./client.jl:275
 [8] _start() at ./client.jl:371
while loading /home/nrw/.juliarc.jl, in expression starting on line 1


```

Ah,  remove `.julia_history and .juliarc.jl` files.


Pkg.init()
Pkg.add("IJulia")
using IJulia


========================================================[ ERROR: IJulia ]========================================================

LoadError: could not spawn `jupyter-kernelspec install --replace --user /tmp/julia-0.6`: no such file or directory (ENOENT)
while loading /home/nrw/.julia/v0.6/IJulia/deps/build.jl, in expression starting on line 103

=================================================================================================================================

========================================================[ BUILD ERRORS ]=========================================================

WARNING: IJulia had build errors.

 - packages with build errors remain installed in /home/nrw/.julia/v0.6
 - build the package(s) and all dependencies with `Pkg.build("IJulia")`
 - build a single package by running its `deps/build.jl` script





sudo julia
> Pkg.add("IJulia")


nrw@chai:~$ sudo apt-get remove julia
https://github.com/JuliaLang/IJulia.jl/issues/379


It sounds like you haven't fully installed jupyter.


nrw@chai:/usr/local/bin$ which jupyter
/usr/local/bin/jupyter


jupyter-kernelspec 
command not found


@ Maybe my jupyter install is bad.

pip install --upgrade --force-reinstall --no-cache-dir jupyter

://stackoverflow.com/questions/42648610/error-when-executing-jupyter-notebook-no-such-file-or-directory#42667069


https://stackoverflow.com/questions/41674368/pip-refuses-to-upgrade


nrw@chai:/usr/local/bin$ sudo apt install python-pip
python-pip is already the newest version (8.1.1-2ubuntu0.4).


@ Pkg.init() -> Pkg.update()


https://github.com/JuliaLang/IJulia.jl/issues/559


-> jupyter 4.3.0

sudo pip install -U jupyter



    IPython 6.0+ does not support Python 2.6, 2.7, 3.0, 3.1, or 3.2.
    When using Python 2.7, please install IPython 5.x LTS Long Term Support version.
    Beginning with IPython 6.0, Python 3.3 and above is required.
    
    See IPython `README.rst` file for more information:
    
        https://github.com/ipython/ipython/blob/master/README.rst
    
    Python sys.version_info(major=2, minor=7, micro=12, releaselevel='final', serial=0) detected.
    Your pip version is out of date, please install pip >= 9.0.1. pip 8.1.1 detected.
    
    

pip install ipython --user


@ I have python3 but it's not default 
Python 2.7.12 (default, Nov 19 2016, 06:48:10) 
IPython 2.4.1 -- An enhanced Interactive Python.

nrw@chai:/usr/local/bin$ pip install 'ipython>=5.0.0, <6'

Collecting ipython<6,>=5.0.0
  Downloading ipython-5.5.0-py2-none-any.whl

nrw@chai:/usr/local/bin$ jupyter --version
4.3.0

nrw@chai:/usr/local/bin$ sudo pip install --upgrade jupyter


Requirement already up-to-date: nbconvert in /usr/local/lib/python2.7/dist-packages/nbconvert-5.3.1-py2.7.egg (from jupyter)
Collecting ipython>=4.0.0 (from ipykernel->jupyter)
  Downloading ipython-6.2.1.tar.gz (5.1MB)
    100% |████████████████████████████████| 5.1MB 272kB/s 
    Complete output from command python setup.py egg_info:
    
    IPython 6.0+ does not support Python 2.6, 2.7, 3.0, 3.1, or 3.2.


jupyter kernelspec -h

r executing Jupyter command 'kernelspec': [Errno 2] No such file or directory


://github.com/JuliaLang/IJulia.jl/issues/453
pip uninstall jupyter-client; pip install jupyter-client

nrw@chai:/usr/local/bin$ which -a jupyter-kernelspec
/home/nrw/.local/bin/jupyter-kernelspec


@ FINALLY.

Okay. Pkg.add("Plots"), 
Pkg.add("GR")
Pkg.add("GeometryTypes

julia> gr()
WARNING: Couldn't initialize gr.  (might need to install it?)
INFO: To do a standard install of gr, copy and run this:

Pkg.add("GR")
Pkg.build("GR")


```
x = 1:10; y = rand(10,2) # 2 columns means two lines
plot(x,y)
```
@WORKS AGAIN whooooooo


#

julia> Pkg.add("DataStructures")



###
Plot things


 https://github.com/JuliaGeometry/GeometryTypes.jl/blob/7bf380a0d6aa8a4249606b6e0987ce4149788cbb/test/lines.jl
         a = LineSegment(Point2f0(0,0), Point2f0(1,0))
 plot!(beam, m=(:yellow,0.3))


@ hmm, well I guess gr() doesn't support alpha, and none of these support
shapes (stroke, color, etc.) like hoped. esp. glvisualize() doesn't even color
in the shape correctly... I should investigate fill() later


##

julia> a = Vector{Int64}
Array{Int64,1}

julia> push(a, 1)
ERROR: UndefVarError: push not defined

julia> push!(a,1)
ERROR: MethodError: no method matching push!(::Type{Array{Int64,1}}, ::Int64)


@ missing paranethsis! 
a> a = Vector{Int64}()
0-element Array{Int64,1}



# 
SIGH,


 julia> vecPt = Vector{Point}()
0-element Array{GeometryTypes.Point,1}

julia> push!(vecPt, Point(2,3))
ERROR: UndefVarError: SV not defined
Stacktrace:
 [1] push!(::Array{GeometryTypes.Point,1}, ::GeometryTypes.Point{2,Int64}) at ./array.jl:617



# pidgin
`:s/.*: / `
(remove name and timestamp from log copy paste)

oh, huh
that's a bug in GeometryTypes
one sec
ok yeah
this PR will fix it
https://github.com/JuliaArrays/StaticArrays.jl/pull/326
but there's an easy workaround which will be faster anyway
which is that whenever you're dealing with vectors, it will always be more efficient to concretely specify the element type
so, instead of Vector{Point}, you want Vector{Point{2, Int}} or Vector{Point{3, Float32}} etc.
which will also, conveniently, avoid triggering this particular issue
https://docs.julialang.org/en/latest/manual/performance-tips/#Avoid-containers-with-abstract-type-parameters-1

Oneato thanks!
So uh how does the 3f0 magic relate to this then
Is point3f0(1,2,3) he same as
Point{3, float 64}(1,2,3)
yeah (but Float32, not Float64)


no, there's no automatic aliasing
those all were created by hand
https://github.com/JuliaGeometry/GeometryTypes.jl/blob/master/src/typealias.jl#L1
although in this particular case using some metaprogramming magic
but, in general, you only have Point3f0 == Point{3, Float32} because some piece of code said:
const Point3f0 = Point{3, Float32}


# onwards
julia> using GeometryTypes

julia> Point3f0
GeometryTypes.Point{3,Float32}

julia> Point3f0 === Point{3, Float32}
true


# null / void
In many settings, you need to interact with a value of type T that may or may
not exist. To handle these settings, Julia provides a parametric type called
Nullable{T}, which can be thought of as a specialized container type that can
contain either zero or one values. Nullable{T} provides a minimal interface
designed to ensure that interactions with missing values are safe. At present,
the interface consists of several possible interactions:


# optional parameters in a sturct

Sometimes, it's just convenient to be able to construct objects with fewer or
different types of parameters than they have fields. Julia's system for object
construction addresses all of these cases and more.


# null and void
https://docs.julialang.org/en/latest/manual/faq/#How-does-"null"-or-"nothingness"-work-in-Julia?-1


isdefined
nothing


# 

ERROR: LoadError: UndefVarError: GeometryTypes not defined
@ `using GeometryTypes` has to be used in the (sub)module definition! weird

julia> width(rect1)
ERROR: MethodError: no method matching width(::GeometryTypes.HyperRectangle{2,Float64})
Closest candidates are:
  width(::GeometryTypes.SimpleRectangle) at /home/nrw/.julia/v0.6/GeometryTypes/src/hyperrectangles.jl:187

julia> 


https://github.com/JuliaGeometry/GeometryTypes.jl/blob/3cf662d4819598d65355708481dcf2834f785541/src/types.jl
struct SimpleRectangle{T} <: GeometryPrimitive{2, T}
    x::T
    y::T
    w::T
    h::T
end


https://github.com/JuliaGeometry/GeometryTypes.jl/blob/3cf662d4819598d65355708481dcf2834f785541/src/types.jl

struct HyperRectangle{N, T} <: GeometryPrimitive{N, T}
    origin::Vec{N, T}
    widths::Vec{N, T}
end



#
hmm. let's have redundant information for edge for now. so linesegment, and start and end nodes.

#
ueERROR: LoadError: MethodError: no method matching push!(::Type{Array{GeometryTypes.Simplex{2,T} where T,1}}, ::GeometryTypes.Simplex{2,GeometryTypes.Point{2,Int64}})
Closest candidates are:

--> Make sure to include () at the end of a vector description


###
GUHHHHHHHHHHHhhhhhhhhhhhhhhhhhhhhhhhhhhhh
it doesn't check for line vs rectangle

https://github.com/JuliaGeometry/GeometryTypes.jl/blob/3cf662d4819598d65355708481dcf2834f785541/src/lines.jl



An alias for a one-simplex, corresponding to LineSegment{T} -> Simplex{2,T}.
"""
const LineSegment{T} = Simplex{2,T}

nl = LineSegment(Point(6,8), Point(-1,0))

://github.com/JuliaGeometry/GeometryTypes.jl/blob/d33cceaf300d6febac22ce751eef60a4d5619948/test/simplices.jl

@testset "1d simplex in 2d" begin
	s = Simplex((Vec(-1.0, 1.), Vec(1.0, 1.)))


https://github.com/JuliaGeometry/GeometryTypes.jl/blob/3cf662d4819598d65355708481dcf2834f785541/src/operations.jl
`min_euclidean(r1::Vec, r2::HyperRectangle) = sqrt(min_euclideansq(r1, r2))`


WTF is the difference between vectors and points????

ANYHOW key is to get collision between line and rectangle working, and then the rest can follow.




##

```
julia> min_euclidean(bline, rect3)
0.0

vs


julia> min_euclidean(bline, rect5)
ERROR: MethodError: no method matching proj_sqdist(::GeometryTypes.Point{2,Float64}, ::GeometryTypes.Point{2,Float64}, ::Float64)
Closest candidates are:
  proj_sqdist(::T, ::GeometryTypes.Simplex{2,T}, ::Any) where T at /home/nrw/.julia/v0.6/GeometryTypes/src/simplices.jl:119
  proj_sqdist(::T, ::GeometryTypes.Simplex{1,T}, ::Any) where T at /home/nrw/.julia/v0.6/GeometryTypes/src/simplices.jl:182
  proj_sqdist(::T, ::GeometryTypes.Simplex{nv,T}, ::Any) where {nv, T} at /home/nrw/.julia/v0.6/GeometryTypes/src/simplices.jl:147
  ...


```
julia> max_euclidean(rect2, cline)
ERROR: MethodError: no method matching max_euclidean(::GeometryTypes.HyperRectangle{2,Float64}, ::GeometryTypes.Simplex{2,GeometryTypes.Point{2,Int64}})
Closest candidates are:
  max_euclidean(::GeometryTypes.HyperRectangle{N,T}, ::Union{GeometryTypes.HyperRectangle{N,T}, GeometryTypes.Vec{N,T}}) where {N, T} at /home/nrw/.julia/v0.6/GeometryTypes/src/operations.jl:76

```

##

SIGH I GUESS THIS IS WHAT PEOPLE DO
so I can't blame julia libraries too much
although holy smokes there is zero documentation for these librarieessssss

https://en.sfml-dev.org/forums/index.php?topic=15268.0

However you could also make 4 lines out of the rectangle and check for
line-line-intersection with each line, which would give you the intersection
points too ;) 
There is one case that is not handled by the idea given by
@templatetypedef: the case where the two endpoints of the line segment are
inside the rectangle. But that case is easy to check: x1 < x3 && x3 < x2 && y1
< y3 && y3 < y2



##

plotting transparent rectangles:
WTF who knows.


julia> plot!(Shape(XRECT, YRECT), lw=10, markeralpha=1, fillalpha=0.4)
Error showing value of type Plots.Plot{Plots.PyPlotBackend}:
ERROR: PyError (ccall(@pysym(:PyObject_Call), PyPtr, (PyPtr, PyPtr, PyPtr), o, arg, kw)) <type 'exceptions.ValueError'>
ValueError(u'RGBA values should be within 0-1 range',)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/patches.py", line 919, in __init__
    Patch.__init__(self, **kwargs)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/patches.py", line 126, in __init__
    self.set_facecolor(facecolor)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/patches.py", line 334, in set_facecolor
    self._set_facecolor(color)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/patches.py", line 324, in _set_facecolor
    self._facecolor = colors.to_rgba(color, alpha)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/colors.py", line 143, in to_rgba
    rgba = _to_rgba_no_colorcycle(c, alpha)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/colors.py", line 204, in _to_rgba_no_colorcycle
    raise ValueError("RGBA values should be within 0-1 range")



##

GKS_WSTYPE=cairox11


##

WHELP it was all caused by cinnamon (my alpha GR issues)

OKAY okay okay now to implmenet four line intersection. Checking if endpoitns in the rectangle is given already.



##
testl = LineSegment(Point(0.,0), Point(5.,5)) #remember to use period for float64 instead of int64

julia> intersects(testl, testl3)
ERROR: MethodError: no method matching eps(::Type{Int64})
Closest candidates are:
  eps(::Base.Dates.Time) at dates/types.jl:331
  eps(::Date) at dates/types.jl:330
  eps(::DateTime) at dates/types.jl:329
  ...
Stacktrace:
 [1] intersects(::GeometryTypes.Simplex{2,GeometryTypes.Point{2,Int64}}, ::GeometryTypes.Simplex{2,GeometryTypes.Point{2,Int64}}) at /home/nrw/.julia/v0.6/GeometryTypes/src/lines.jl:34



This test cannot tell collinear lines. uhhhhhhhhhhhhh . well we'll leave that for now.
TODO: collinear lines 
