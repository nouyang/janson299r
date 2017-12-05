```
min_euclidean(Vec(f

    mutable struct TreeNode 
        id::Int64
        parentID::Int64
        state::Point{2, Float64}
        cost::Float64
        TreeNode() = new()
    end



# cannot find module in current path


I had a space in front of the path.

vi ~/.juliarc.jl
push!(LOAD_PATH, "/home/nrw/Documents/299r/janson299r/wk11")


# sigh  float vs int not automatic

MethodError: Cannot `convert` an object of type Void to an object of type Int64
This may have arisen from a call to the constructor Int64(...),
since type constructors fall back to convert methods.

MethodError: no method matching Node(::Int64, ::Int64, ::GeometryTypes.Point{2,Float64}, ::Int64)
Closest candidates are:
  Node(::Int64, ::Int64, ::GeometryTypes.Point{2,Float64}) at In[44]:9
  Node(::Int64, ::Int64, ::GeometryTypes.Point{2,Float64}, ::Float64) at In[44]:10
  Node(::Int64, ::GeometryTypes.Point{2,Float64}) at In[44]:8

S

# WHY 
@show c[1]


foo =3 

findfirst(alist) do pt

    @show pt[1]

    @show foo

    b = pt[1]

    @show typo

    2 == 3

    pt

end

@show pt


c[1] = 5
pt[1] = 2
foo = 3
typeof(b) = Int64
typeof(3) = Int64

TypeError: non-boolean (Int64) used in boolean context


## answer was something like, i confused the fact that we're handing in a list and finding the first index of soething happening per item
```
# 

using algT

algT.Ro

UndefVarError: Room not defined

Stacktrace:
 [1] include_string(::String, ::String) at ./loading.jl:522


#
GUH WHY DOES everything havve to be in a module for y tyeps to import?!

include("testRRT.jl")
plotly()
main()
LoadError: LoadError: UndefVarError: AlgParameters not defined

# GUHhhhhhhh

import algT
algT.Nod

UndefVarError: Node not definede


The error is something like LoadError: TypeError: Type{...} expression: expected UnionAll, got Type{GeometryTypes.Point{2,Float64}} while loading/algT.jl, in expression starting on line 8 and/or
LoadError: UndefVarError: T not defined

## solution

I had {T} sprinkled throughout the rest of the code.
Also, type aliasing doesnt use the {T} but does use the {} and NOT the ()



# Pkg.add("Revise")
using Revise

# o29.
ERROR: MethodError: Cannot `convert` an object of type Int64 to an object of type GeometryTypes.Point{2,Float64}
This may have arisen from a call to the constructor GeometryTypes.Point{2,Float64}(...),
since type constructors fall back to convert methods.
Stacktrace:

## was using UNDEF=int instesad of Pt2D(UNDEF)

#

29.
ERROR: MethodError: GeometryTypes.Simplex{2,GeometryTypes.Point{2,Float64}}(::GeometryTypes.Point{2,Float64}) is ambiguous. Candidates:
  (::Type{GeometryTypes.Simplex{S,T}})(x) where {S, T} in GeometryTypes at /home/nrw/.julia/v0.6/GeometryTypes/src/simplices.jl:10
  (::Type{S})(sv::StaticArrays.StaticArray{Tuple{N},T,1} where T where N) where S<:GeometryTypes.Simplex in GeometryTypes at /home/nrw/.julia/v0.6/GeometryTypes/src/simplices.jl:6
Possible fix, define
  (::Type{GeometryTypes.Simplex{S,T}})(::StaticArrays.StaticArray{Tuple{N},T,1} where T where N)

##
was giving it ints [1,2] instead of Point(1,2)


# attempting optional args


julia> using algT; f = algT.Node(1, Point(2., 2.), 3, 23.234)
algT.Node(140729224791776, 5, [6.95295e-310, 6.90897e-310], 2.5e-323)

julia> using algT; f = algT.Node(1, Point(2., 2.))
ERROR: MethodError: no method matching algT.Node(::Int64, ::GeometryTypes.Point{2,Float64}, ::Void, ::Void)
Closest candidates are:
  algT.Node(::Int64, ::GeometryTypes.Point{2,Float64}) at /home/nrw/Documents/299r/janson299r/wk11/algT.jl:11
  algT.Node(::Int64, ::GeometryTypes.Point{2,Float64}, ::Int64) at /home/nrw/Documents/299r/janson299r/wk11/algT.jl:11
  algT.Node(::Int64, ::GeometryTypes.Point{2,Float64}, ::Int64, ::Float64) at /home/nrw/Documents/299r/janson299r/wk11/algT.jl:11
  ...
Stacktrace:
 [1] algT.Node(::Int64, ::GeometryTypes.Point{2,Float64}) at /home/nrw/Documents/299r/janson299r/wk11/algT.jl:11

## gotta make sure the arguments in the type are in the write order. also, 
 replacing module algT
ERROR: LoadError: invalid redefinition of constant Node
Stacktrace:


> i cannot get outer constructiion to workk, e.g. function Node(a,y,c = nothing) = Node(a,y)

# 

WARNING: replacing module algT
ERROR: LoadError: syntax: optional positional arguments must occur at end
Stacktrace:
 [1] include_from_node1(::String) at ./loading.jl:576

## basically, do what it says, everything with a default value (has `=` is an optional argument)


# 

ERROR: TypeError: non-boolean (Tuple{Bool,GeometryTypes.Point{2,Float64}}) used in boolean context


#
 I just realized.

A lot of the issues may have come from differences in how my intersect() code and the library code handles corners,
e.g. coincident things.
## 

# TODO !!!!!!!!!!!!!!!!!!!

Cannot set start state as 0,0 anymore

#

ERROR: MethodError: Cannot `convert` an object of type algT.Node to an object of type algT.Node
This may have arisen from a call to the constructor algT.Node(...),
since type constructors fall back to convert methods.


##
in the module, was calling Node instea of algT.node

h
        startstate::Pt2D
        goalstate::Pt2D
        nodeslist::Vector{algT.Node}
        edgeslist::Vector{algT.Edge}

# No ndes were showing up

## TOFIX (or at least not fail silently)
Cannot set start state as 0,0 anymore

# hmm. parent id is the same is id

