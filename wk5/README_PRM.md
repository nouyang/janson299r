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

## sort by second row
julia> sort(a, by=a->a[2])

