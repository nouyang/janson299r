```
Pkg.add("Interact")
Pkg.add("IJulia")

using IJulia
julia> notebook(dir=".");


julia> Pkg.clone("git@github.com:rdeits/AgileRoboticsTutorial.jl")


>> https://github.com/stevengj/18S096-iap17/blob/master/lecture1/Boxes-and-registers.ipynb

@code_warntype mysum1(a)
 If it labels any variables (or the function's return value) as Any or
 Union{...}, it means that the compiler couldn't figure out a precise type.

@simd for a in A

@code_llvm f(1)

de_native f(1)




Out[34]:

mysqrt (generic function with 2 methods)

This definition is an example of Julia's multiple dispatch style, which in some
sense is a generalization of object-oriented programming but focuses on "verbs"
(functions) rather than nouns.


type Point1
    x
    y
end

Base.:+(p::Point1, q::Point1) = Point1(p.x + q.x, p.y + q.y)
Base.zero(::Type{Point1}) = Point1(0,0)


Base.:-(p::Point1, q::Point1) = Point1(p.x - q.x, p.y - q.y)
Base.abs(p::Point1) = hypot(p.x, p.y) # sqrt(p.x^2 + p.y^2)
relerr(sum(a1),mysum3(a1))




immutable Point3{T<:Real}
    x::T
    y::T
end

Base.:+(p::Point3, q::Point3) = Point3(p.x + q.x, p.y + q.y)
Base.zero{T}(::Type{Point3{T}}) = Point3(zero(T),zero(T))

Point3(3,4)


Here, Point3 is actually a family of subtypes Point{T} for different types T.
The notation <: in Julia means "is a subtype of", and hence T<:Real means that
we are constraining T to be a Real type (a built-in abstract type in Julia that
includes e.g. integers or floating point).
```


```



https://pkg.julialang.org/

DEPRECATED https://github.com/johnmyleswhite/Benchmark.jl
DEPRECATED https://github.com/johnmyleswhite/Benchmarks.jl



https://github.com/JuliaCI/BenchmarkTools.jl



OOohhhh
The [*] indicates if a cell is currently running
```


# More Useful Julia Packages

There are a wide variety of cool Julia packages that we won't have time to cover today. You might find some of these useful in your robotics work:

[Plots.jl](https://github.com/JuliaPlots/Plots.jl) Extremely powerful plotting tool, with support for a variety of different plotting backends

[RobotOS.jl](https://github.com/jdlangs/RobotOS.jl)
Julia bindings to ROS

[Caesar.jl](https://github.com/dehann/Caesar.jl)
A robotics toolkit for mapping and localization

[DifferentialEquations.jl](https://github.com/JuliaDiffEq/DifferentialEquations.jl)
An entire suite of tools for a variety of diff eq. problems. Includes tools for:

* ODEs & PDEs
* stochastic ODEs & PDEs
* discrete equations
* delay differential equations

[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl)
Automatic generation of Julia package documentation, with nice GitHub integration. 

[DataFrames.jl](https://github.com/JuliaStats/DataFrames.jl)
Tabular data and statistical tools. 

[Images.jl](https://github.com/JuliaImages/Images.jl )
Elegant, efficient image maniuplation. 

[PyCall.jl](https://github.com/JuliaPy/PyCall.jl)
Call Python from Julia easily

[GeometryTypes.jl](https://github.com/JuliaGeometry/GeometryTypes.jl) Geometric primitives and meshes

[ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) Efficient forward-mode automatic differentiation

[HypothesisTests.jl](https://github.com/JuliaStats/HypothesisTests.jl) Statistical hypothesis tests




## Errors

```
DrakeVisualizer.any_open_windows() || DrakeVisualizer.new_window();
vis = Visualizer(parse_urdf(urdf, doublependulum));
```

```
MethodError: Cannot `convert` an object of type Type{GeometryTypes.Vec} to an object of type StaticArrays.Size
This may have arisen from a call to the constructor StaticArrays.Size(...),
since type constructors fall back to convert methods.

Stacktrace:
 [1] convert at /home/nrw/.julia/v0.6/StaticArrays/src/convert.jl:17 [inlined]
 [2] Type at /home/nrw/.julia/v0.6/StaticArrays/src/convert.jl:4 [inlined]
 [3] parse_geometry(::Type{Float64}, ::LightXML.XMLElement, ::Array{SubString{String},1}) at /home/nrw/.julia/v0.6/RigidBodyTreeInspector/src/parse_urdf.jl:35
 [4] #parse_urdf_visuals#46(::Array{SubString{String},1}, ::Function, ::String, ::RigidBodyDynamics.Mechanism{Float64}) at /home/nrw/.julia/v0.6/RigidBodyTreeInspector/src/parse_urdf.jl:123
 [5] parse_urdf_visuals(::String, ::RigidBodyDynamics.Mechanism{Float64}) at /home/nrw/.julia/v0.6/RigidBodyTreeInspector/src/parse_urdf.jl:106
 [6] #parse_urdf#49(::Array{Any,1}, ::Function, ::String, ::Vararg{Any,N} where N) at /home/nrw/.julia/v0.6/RigidBodyTreeInspector/src/parse_urdf.jl:154
 [7] parse_urdf(::String, ::RigidBodyDynamics.Mechanism{Float64}) at /home/nrw/.julia/v0.6/RigidBodyTreeInspector/src/parse_urdf.jl:154
 [8] include_string(::String, ::String) at ./loading.jl:515
 ```



# change directory

` julia> cd("/home/nrw/projects/julia/AgileRoboticsTutorial.jl/") `
pwd()


# error

```

doublependulum = parse_urdf(Float64, urdf)
ERROR: LightXML.XMLParseError{String}("Failure in parsing an XML file.")

```




# RbooticsJuliaCon2017

```
julia> Pkg.clone("https://github.com/tkoolen/RoboticsJuliaCon2017.jl")
```


: ah, I think I figured it out. Based on
https://github.com/tkoolen/RoboticsJuliaCon2017.jl/blob/master/notebook/1.%20Model-predictive%20control%20with%20JuMP.ipynb
the syntax should be 

`vis = Visualizer(parse_urdf(Float64, urdf));` instead of
`vis = Visualizer(parse_urdf(urdf, doublependulum))

.... or I suppose just `vis = Visualizer(doublependulum);`


# to run a file:
 julia > ;
 shell> julia FILENAME.jl

 This works with the up arow key

julia> include("RRT.jl")



# vim jupyter

nrw@chai:~/.local/share/jupyter/nbextensions$ 


# pygame



# SFML

'''
julia> Pkg.build("SFML")
INFO: Building SFML
==============================================================[ ERROR: SFML ]===============================================================

LoadError: UndefVarError: @windows_only not defined
while loading /home/nrw/.julia/v0.6/SFML/deps/build.jl, in expression starting on line 1

```

https://gist.github.com/NoobsArePeople2/8086528


```sudo apt-get install -y libpthread-stubs0-dev libgl1-mesa-dev libx11-dev
libxrandr-dev libfreetype6-dev libglew1.5-dev libjpeg8-dev libsndfile1-dev
libopenal-dev libudev-dev libxcb-image0-dev libjpeg-dev libflac-dev```

SIGH using beta languages

https://github.com/zyedidia/SFML.jl/issues/38

` julia> Pkg.rm("SFML.jl") `



edit 
vi /home/nrw/.julia/v0.6/SFML/deps/build.jl
WORD_SIZE=64
aka getconf LONG_BIT



```
julia> include("pong.jl")
Could not resolve dependencies:
        libGLEW.so.1.10 => not found
        Something has gone wrong with the SFML installation.
        ErrorException("could not load library \"libsfml-graphics\"\nlibGLEW.so.1.10: cannot open shared object file: No such file or directory")
        ERROR: LoadError: error compiling main: could not load library "libjuliasfml"
        /home/nrw/.julia/v0.6/SFML/src/../deps/libjuliasfml.so: undefined symbol: sfTransform_Identity
```

`nrw@chai:~/.julia/v0.6/SFML/deps(master)$ ls `

```

gcc -I/usr/local/include -L/usr/local/lib -lsfml-graphics -lsfml-system
-lsfml-window -lsfml-network -lsfml-audio -lcsfml-network -lcsfml-graphics
-lcsfml-system -lcsfml-window -lcsfml-audio -o $1 $1.c


find -name *.sh


vi deps/sfml/share/SFML/cmake/Modules/FindSFML.cmake



https://github.com/zyedidia/SFML.jl/issues/36

sudo apt remove libglew1.5-dev
sudo apt install libglew1.10-dev



Package libglew1.10-dev is not available, but is referred to by another package.


sudo apt remove libglew

sudo apt install libglew1.10-dev


https://stackoverflow.com/questions/20256085/how-do-i-install-libglew-1-5-for-sfml-2-0

$ libglew-dev is already the newest version (1.13.0-2).



sudo ln -s /dev/lib/libGLEW.so.1.9 /dev/lib/libGLEW.so.1.5
sudo ln -s /dev/lib/libGLEW.so.1.13 /dev/lib/libGLEW.so.1.10


https://packages.ubuntu.com/trusty/libglew1.10

sudo ln -s /usr/lib/x86_64-linux-gnu/libGLEW.so.1.13 /usr/lib/x86_64-linux-gnu/libGLEW.so.1.10

$ cd("/home/nrw/Documents/fall 2017/299r/wk1")
$ include("pong.jl)
```


# animacioniterador.ipynb

http://localhost:8888/notebooks/SimpleAnimation/animacioniterador.ipynb
nrw@chai:~/Documents/fall 2017/299r/RRT/SimpleAnimation(master)$ sudo pip install matplotlib

pygui(true)G
UndefVarError: backend not defined

https://github.com/JuliaPy/PyPlot.jl


TypeError('PyCall.jlwrap object is not an iterator',)

https://stackoverflow.com/questions/35142199/implementing-an-iterator-in-julia-for-an-animation-with-pyplot


FIXED by code above.

http://localhost:8889/notebooks/SimpleAnimation/animacioniterador.ipynb

## pygame

error("Couldn't open ball.bmp",)

# okay RRT matlab illinois

WELL I'm running out of time -- so let's go back to the single file dirty matlab implementation. 
Not sure how to deal with the plotting issue -- for now just port code and get it working!!

http://coecsl.ece.illinois.edu/ge423/spring13/RickRekoskeAvoid/rrt.html
nrw@chai:~/Documents/fall 2017/299r/wk1/RRT_illinois(master)$ mv Simple2obst.txt Simple2Obst.txt 


this outputs static graphs.

I remember not liking some parts of this implementation... let's take a look.



# well back to a static file, bleah jupyter and graphs

https://docs.julialang.org/en/stable/manual/functions/

```

	Here's the initial configuration.

	Hefty first picks a random location (qRandom) somewhere on the board.

	A node (qNew) is then added to the path in the direction of qRandom a
maximum distance of EPSILON away from the nearest node already in the path
(qNear) which currently is Hefty's position.

	The algorithm then checks if there is a path to qNew from the closest node
in the tree starting at the ball. In this case, there isn't so the algorithm
continues.

	The trees then switch roles. A new qRandom (not shown) is selected and then
a new node is added to the tree rooted at the ball.

	The algorithm then checks if there is a path from the new node to the
closest node in the tree rooted at Hefty (there isn't).

	The trees switch roles again and a new node is added to Hefty's tree. The
node is connected to the closest node already in the tree, which in this case
is the last node added.

	The algorithm then checks if there is a path from the new node to the
closest node in the ball's tree. Since there is, the tree returns this path.
```

# frustrating errors

 3ERROR: LoadError: invalid redefinition of constant Obstacle



# Julia Demos

Animated Gifs
https://github.com/rdeits/AgileRoboticsTutorial.jl/blob/master/notebooks/6.%20Optimization%20with%20JuMP.ipynb

Slider cat
http://localhost:8888/notebooks/RoboticsJuliaCon2017.jl/notebook/Easy%203D%20Visualizations.ipynb


Slider robot? :'(
http://localhost:8888/notebooks/AgileRoboticsTutorial.jl/notebooks/3.%20RigidBodyDynamics.ipynb
