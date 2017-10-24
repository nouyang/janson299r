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

