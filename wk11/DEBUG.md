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

​

foo =3 

findfirst(alist) do pt

    @show pt[1]

    @show foo

    b = pt[1]

    @show typo

    2 == 3

    pt

end

​

@show pt

​

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
