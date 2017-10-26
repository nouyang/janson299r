include("PRM.jl")
pyplot()

connectRadius = 8

startstate = Point(1.,1)
goalstate = Point(20.,20)

# create obstacles (fixed map for now)
obs1 = HyperRectangle(Vec(8,3.), Vec(2,2.)) #Todo
obs2 = HyperRectangle(Vec(4,4.), Vec(2,10.)) #Todo

obstacles = Vector{HyperRectangle}()
push!(obstacles, obs1, obs2)

# create room
walls = Vector{LineSegment}()
w,h  = 20,20
perimeter = HyperRectangle(Vec(0.,0), Vec(w,h))
roomPerimeter = algfxn.decompRect(perimeter)
for l in roomPerimeter
    push!(walls, l)
end

r = algT.Room(w,h,walls,obstacles)


# implement function to create clutter


# sample n times for each clutter type


# todo: save one "representative" figure from each run
