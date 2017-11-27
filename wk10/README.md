# wk8
END DATE: 11/28/2017
Well. Tasks to do: 

Implement `RRT*, PRM*, and FMT*`

# To run
use 
`clutter_with_errorbars.jl`
and 
`walls_experiment.jl`


# IPython Notebook

> Install Julia (I'm using version 0.6)

Add useful packages, either https://pkg.julialang.org or from a github repo.
(note: many of the "official registered" packages may be for a specific version

> Pkg.add("Plots")
> Pkg.clone("some/git/repo")


To use the Jupyter interactive browser-based "notebook"
> Pkg.add("IJulia")

julia> using IJulia; notebook(detached=true, dir=".")



To run a file,
> include("RRT.jl")

> cd()
> pwd()



# Plots

I switched to the plotly() backend. I thought it was a weird cloud service and
ignored it, but it seems like the default is to not contact the cloud server,
so I don't need to make an account or anything and it works offline.  The plot
has zoom and resize and all the features I want, although I still hanker for a
"click and edit" system that would, for instance, allow me to fix the title
font. Guh. I really can't figure out how to make any long text break line and
wrap correctly.

See an example in (/screenshots/wk10_testPRM.jl_withobstacles.html)
and a static iJulia render at (/screenshots/Screenshot-2017-11-26 Interactive PRM Plotting.png)

It looks fancy but the primary advantage over GR and others is being able to
zoom in and resize and pan the plot. Oh, an also labels show up consistently,
and there's never "frozen windows". The IJulia integration (it actually shows
up) is nice too. The "info" datapoints are a little distracting, since they
don't makes sense the way I'm plotting things.  though the "spike
lines" might be convenient.


## plot title 

The usual issues.
Font attribute does not seem to impact jupyter rendering of plotly graphs, although you can at least change the actual font.
But I can't get "bold" to show up. ("Courier Bold" does not work).
For now, leave in a small font size, as it does not impact jupyter (ijulia),
and allows the "new tab" on plotly to render all the text contents visibly.


## formattng timestamp

<https://en.wikibooks.org/wiki/Introducing_Julia/Working_with_dates_and_times#Date_formatting>
    timestamp = Base.Dates.now()
    timestamp = Base.Dates.format(timestamp, "dd u yyyy HH:MM:SS")



# colors

are css colors

<https://developer.mozilla.org/en-US/docs/Web/CSS/color_value>

        plot!(aPlot, obstacles, fillalpha=0.8)
        color := :grey #:indigo goes well with the orange lines too
        #linecolor := :orange


# PRM*

That was a simple matter of redefining the radius as a function of the roomsize
and the dimensions, in this case 2. However... it doesn't seem quite reasonable.
For a sample size of 500 the connection radius becomes 2, and it returns a much
more suboptimal path than just 200 points with a connect radius of 5... ??

I'll leave it be for now.

#  Port RRT

The next step is to get optimal RRT. It may be better to start straight with
`RRT*` as this will force me to modularize the code correctly. (what works for
`RRT*` should work easily for RRT). But, maybe best to just start with RRT.

Also, I rather wish to fix up all the graphs of clutter and cost and iterations,
since this will force me to consider the data and modularity of the code as
well. oh well.

# Write RRT*

This is "rewiring the tree" each time we add a node, consider all neighbors and
find minimum of the total path cost through any of these neighbors.

# FMT*

Oh boy. Time for some fun algorithm writeups.
It is most similar to PRM. It needs the "total path cost" same as `RRT*`.

Section 3.4 has the implementation details. For saving computational costs we
will want a binary min heap for Vopen, ordered by cost-to-arrive. But ignore
this for now.`
