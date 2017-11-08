So it begins...

#  savefig() and png()
ERROR: LoadError: SystemError: opening file /tmp/juliaBXZXtb.png: No such file or directory

Appears to be specific to gr() backend. sigh.


# plot is very finicky

theory: relying on global state

julia> x = 1:10; y = rand(10) # These are the plotting data
10-element Array{Float64,1}:
 0.0501807
 0.34642  
 0.733626 
 0.403945 
 0.12979  
 0.13897  
 0.372945 
 0.494988 
 0.999612 
 0.856944 

julia> plot(x,y)

julia> plot(x,y);

julia> plot!(x,y)

julia> plot(x,y)

julia> plot!(x,y)

julia> plot(x,y)

julia> plot(x,y)

julia> plot(x,y)

julia> closeall()

julia> closeall()

julia> plot(x,y)

julia> plot()

julia> gui()

julia> plot(x,y)

---> yup this results in sad sad things

julia> plot(x,y)

julia> z= rand(10)^C

julia> plot!(x,z)

--> also sad?!


## switch to glvisualize()? and why is pyplot() so slow?


GLVISUALIZE() is also *super* sad about savefig() and png()o

spits out an interminable string of 
1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0,1.0,1.0) RGB{N0f8}(1.0^C1ERROR: InterruptException:

sigh whatever

# :( segfault
```

 -------- 

signal (11): Segmentation fault
while loading /home/nrw/Documents/fall 2017/299r/janson299r/wk7/clutter_experiment.jl, in expression starting on line 112
pthread_mutex_lock at /lib/x86_64-linux-gnu/libpthread.so.0 (unknown line)
XrmDestroyDatabase at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
_XFreeDisplayStructure at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
XCloseDisplay at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
unknown function (ip: 0x7f70d43a947f)
gks_cairoplugin at /home/nrw/.julia/v0.6/GR/src/../deps/gr/lib/./cairoplugin.so (unknown line)
unknown function (ip: 0x7f70d5a03e09)
gks_set_ws_viewport at /home/nrw/.julia/v0.6/GR/src/../deps/gr/lib/libGR.so (unknown line)


#

julia> plot(foo,x,y)
ERROR: MethodError: Cannot `convert` an object of type String to an object of type MethodError
This may have arisen from a call to the constructor MethodError(...),
since type constructors fall back to convert methods.
Stacktrace:

@  needed to use plot! instead of plot()

# oof anther segfault with glvisualize()
X Error of failed request:  BadWindow (invalid Window parameter)
  Major opcode of failed request:  15 (X_QueryTree)
  Resource id in failed request:  0x4a00053
  Serial number of failed request:  18892
  Current serial number in output stream:  18892

signal (11): Segmentation fault
while loading /home/nrw/Documents/fall 2017/299r/janson299r/wk7/testPRM.jl, in expression starting on line 187
pthread_mutex_lock at /lib/x86_64-linux-gnu/libpthread.so.0 (unknown line)
XrmDestroyDatabase at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
_XFreeDisplayStructure at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
XCloseDisplay at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
unknown function (ip: 0x7f89a40e647f)
gks_cairoplugin at /home/nrw/.julia/v0.6/GR/src/../deps/gr/lib/./cairoplugin.so (unknown line)
unknown function (ip: 0x7f89a5840e09)
gks_close_ws at /home/nrw/.julia/v0.6/GR/src/../deps/gr/lib/libGR.so (unknown line)
gks_emergency_close at /home/nrw/.julia/v0.6/GR/src/../deps/gr/lib/libGR.so (unknown line)
__run_exit_handlers at /build/glibc-bfm8X4/glibc-2.23/stdlib/exit.c:82
exit at /build/glibc-bfm8X4/glibc-2.23/stdlib/exit.c:104
_XDefaultError at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
_XError at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
unknown function (ip: 0x7f89a5206ad6)
_XReply at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
XQueryTree at /usr/lib/x86_64-linux-gnu/libX11.so.6 (unknown line)
Tk_HandleEvent at /usr/lib/x86_64-linux-gnu/libtk8.6.so (unknown line)
unknown function (ip: 0x7f898dcea493)
Tcl_ServiceEvent at /usr/lib/x86_64-linux-gnu/libtcl8.6.so (unknown line)
Tcl_DoOneEvent at /usr/lib/x86_64-linux-gnu/libtcl8.6.so (unknown line)
unknown function (ip: 0x7f898dce332c)
TclNRRunCallbacks at /usr/lib/x86_64-linux-gnu/libtcl8.6.so (unknown line)
unknown function (ip: 0x7f898e376e4f)
PyEval_EvalFrameEx at /usr/lib/x86_64-linux-gnu/libpython2.7.so (unknown line)
PyEval_EvalCodeEx at /usr/lib/x86_64-linux-gnu/libpython2.7.so (unknown line)
unknown function (ip: 0x7f89a1e062df)
PyObject_Call at /usr/lib/x86_64-linux-gnu/libpython2.7.so (unknown line)
unknown function (ip: 0x7f89a1e4d31b)
PyObject_Call at /usr/lib/x86_64-linux-gnu/libpython2.7.so (unknown line)
macro expansion at /home/nrw/.julia/v0.6/PyCall/src/exception.jl:78 [inlined]
#_pycall#67 at /home/nrw/.julia/v0.6/PyCall/src/PyCall.jl:653
#pycall#70 at /home/nrw/.julia/v0.6/PyCall/src/PyCall.jl:672
jl_call_fptr_internal at /home/centos/buildbot/slave/package_tarball64/build/src/julia_internal.h:339 [inlined]
jl_call_method_internal at /home/centos/buildbot/slave/package_tarball64/build/src/julia_internal.h:358 [inlined]
jl_invoke at /home/centos/buildbot/slave/package_tarball64/build/src/gf.c:41
#7 at /home/nrw/.julia/v0.6/PyCall/src/gui.jl:195
#300 at ./event.jl:436
unknown function (ip: 0x7f89a450396f)
jl_call_fptr_internal at /home/centos/buildbot/slave/package_tarball64/build/src/julia_internal.h:339 [inlined]
jl_call_method_internal at /home/centos/buildbot/slave/package_tarball64/build/src/julia_internal.h:358 [inlined]
jl_apply_generic at /home/centos/buildbot/slave/package_tarball64/build/src/gf.c:1933
jl_apply at /home/centos/buildbot/slave/package_tarball64/build/src/julia.h:1424 [inlined]
start_task at /home/centos/buildbot/slave/package_tarball64/build/src/task.c:267
unknown function (ip: 0xffffffffffffffff)
Allocations: 98163771 (Pool: 98156553; Big: 7218); GC: 227
Segmentation fault (core dumped)


# 

 ---- queried ---- 
ERROR: LoadError: MethodError: no method matching plotPRM(::algT.roadmap, ::Type{Void}, ::String)

@ need to use plot =  bloag(); gui(plot) instead of glbaog(); gui()

#
SIGH
glvisualzie() has a tendency to hate 1000 n (as in it will freeze my computer aftwards)

@ HOW TO heck do I clear all old plots()? destory them


# 

Adding in shape : 
Error showing value of type Plots.Plot{Plots.GLVisualizeBackend}:
ERROR: buffer position has not the same length as the other buffers.
              Has: 1. Should have: 5


    pPRMcost = scatter(clutterPercentages, avgCosts',
        markercolor = :black,
        title = supTitle * costTitle, ylabel = "euclidean path cost", xlabel = "clutter %",
        yaxis=((20,40), 0:20:40) , yerr = stddevs, marker = stroke(2, :orange), shape="hline")
        # yerr = yerrCost)

# GUH error bars
one error bars do not change (constant)

    #yerrCost = [0 1.0 2.1 5.1 10.0]
    yerrCost = [0.864606, 0.860516, 1.59285, 5.19058, 2.60185]
    print("type of yerrCost, $(typeof(yerrCost))")
    yerrCost = [0.8 0.8 1.6 5.2 2.6]
    print("type yerrCost, $(typeof(yerrCost))")

type of yerrCost, Array{Float64,1}
type yerrCost, Array{Float64,2}


sooooooooooo we want our list of stddevs to be array of 2 instead of array of 1


WELL taking the transpose fixed it. ????
```

# stddev
I think it's actually a property of stddev. If n =3 ...  (pSuccess = 0.2)
average = very similar to all the points, thus error is small


# plottitle
```
plot_title: title for whole plot, not subplots. note: not currently implemented
```
why
do i do this to myself. why am i using julia

#Plots.scalefontsizes(0.2)
WELL each time I run it it gets smaller and smaller. sigh


# freezing with glvisualize and crashing julia

every so often glvisualize says "cannot start" or something.
solution: take glvisualize() out of top of file


# well glvisualize()
The subplot title is chilling in the middle of the plot...


# 

 ------ 
elapsed time: 3.182331313 seconds
Time to run experiment: 3.182331313
ERROR: LoadError: DivideError: integer division error
