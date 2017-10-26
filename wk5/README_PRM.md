# debug log for fixing PRM

## Goals
arbitrary obs, room(walls), start and end goal;
more robust, library-based collision detection, replacing homebrew;
correct end detection / snapping;



# Debug

## error
WARNING: replacing module algfxn
HiERROR: LoadError: TypeError: Type: in parameter, expected Type, got Array{Type,1}
Stacktrace:
 [1] findNearestNodes(::alg.GraphNode, ::Array{alg.GraphNode,1}, ::Int64) at /home/nrw/Documents/fall 2017/299r/janson299r/wk5/PRM_redo.jl:92
 [2] preprocessPRM(::alg.Room, ::alg.AlgParameters) at /home/nrw/Documents/fall 2017/299r/janson299r/wk5/PRM_redo.jl:128
 [3] main() at /home/nrw/Documents/fall 2017/299r/janson299r/wk5/PRM_redo.jl:169



        nearestNodes = Vector{[Point, Int64]}()


HiERROR: LoadError: InexactError()
Stacktrace:
 [1] convert(::Type{Int64}, ::Float64) at ./float.jl:679
 [2] push!(::Array{Tuple{alg.GraphNode,Int64},1}, ::Tuple{alg.GraphNode,Float64}) at ./array.jl:617
 [3] findNearestNodes(::alg.GraphNode, ::Array{alg.GraphNode,1}, ::Int64) at /home/nrw/Documents/fall 2017/299r/janson299r/wk5/PRM_redo.jl:97
 [4] preprocessPRM(::alg.Room, ::alg.AlgParameters) at /home/nrw/Documents/fall 2017/299r/janson299r/wk5/PRM_redo.jl:129


        nearestNodes = Vector{Tuple{alg.GraphNode, Float64}}()
        nearestNodes = Vector{Tuple{alg.GraphNode, Int64}}()


###
I do like how I can copy and past into the command prompt and it will automatically strip out 'julia>'

## sort by second row
julia> sort(a, by=a->a[2])


## find by a specific field of type in an array
julia> a = alg.GraphNode(1,Point(2,3))
alg.GraphNode(1, [2.0, 3.0])

julia> findfirst(a[1], ^C

julia> b = alg.GraphNode(2,Point(3,1))
alg.GraphNode(2, [3.0, 1.0])

julia> z = [a,b]
2-element Array{alg.GraphNode,1}:
 alg.GraphNode(1, [2.0, 3.0])
 alg.GraphNode(2, [3.0, 1.0])

julia> c = alg.GraphNode(4, Point(3,1))
alg.GraphNode(4, [3.0, 1.0])

julia> d = alg.GraphNode(3,Point(2,1))
alg.GraphNode(3, [2.0, 1.0])

julia> z = [b,a,c,d]
4-element Array{alg.GraphNode,1}:
 alg.GraphNode(2, [3.0, 1.0])
 alg.GraphNode(1, [2.0, 3.0])
 alg.GraphNode(4, [3.0, 1.0])
 alg.GraphNode(3, [2.0, 1.0])

julia> findfirst([foo.id for foo in z], 2)
1

ERROR: LoadError: MethodError: no method matching min_euclidean(::GeometryTypes.Point{2,Float64}, ::GeometryTypes.Point{2,Float64})
Stacktrace:

                    newEdgeCost = min_euclidean(Vec(curNode.state), Vec(candidateNode.state)) #heuristic is dist(state,state). better to pass Node than to perform node lookup everytime (vs passing id)

@ need Vec(Point)

# random pfloat

https://stackoverflow.com/questions/46305156/generating-random-float-points-in-julia

https://www.reddit.com/r/Julia/comments/6au3n5/random_floating_point_number/

# vim search for "alg."
\alg/.

# the type vs initiazlie error again
ulia> a
DataStructures.PriorityQueue

julia> enqueue!(a, 10, 10)
ERROR: MethodError: no method matching enqueue!(::Type{DataStructures.PriorityQueue}, ::Int64, ::Int64)
Closest candidates are:
  enqueue!(::DataStructures.PriorityQueue, ::Any, ::Any) at /home/nrw/.julia/v0.6/DataStructures/src/priorityqueue.jl:238


# markers


http://matplotlib.org/api/markers_api.html

http://docs.juliaplots.org/latest/examples/gr/#animation-with-subplots


# Summary improvements
Allow for plotting an array of arbitrary number of obstacles
Fixed issue with snapping of start and end goals
Switched to random floating point, and not just random integer, for sampling


# Issues
- > Calcified into having rectangular obstacles -- should allow for arbitrary shapes


In retrospect, if I were to allow arbitrary obstacle shapes, I should
definitely go for the "the edge I am checking is a super thin rectangle, that I
am checking against the obstacles" as opposed to "assuming the obstacle is
rectangular, wrte a decompRect function to turn the rectangle into lines."
Admittedly, even in
http://nbviewer.jupyter.org/github/schmrlng/MotionPlanning.jl/blob/master/docs/MotionPlanning.ipynb
The objects are either polygonal or circles. So I could easily decompose the
shape into lines, as before. So either approach would still work. 



## thoughts

Well, this is both embarrassing (what did I spend all my time on??) and also
super useful. Would you prefer / recommend / have no opinion on if I
standardize against their codebase? Right now, for instance, my obstacles are
locked into being rectangular. It wouldn't be much work to allow for arbitrary
polygons using my current approach, but I could instead put that time into
porting over the code.

Eh, but then again, there hasn't been an update in 11 months... maybe a dead
project then.

I'm using both a different geometric/collision-checking module (they define
their own), as well as plotting library (they and I both have specialized
functions for plotting the aforementioned shape types).

