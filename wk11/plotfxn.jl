module plotfxn

    using GeometryTypes
    using Plots
    using algfxn
    using algT

    ###  Plots.jl recipes

    @recipe function f(r::HyperRectangle)
        points = decompose(Point{2,Float64}, r)
        rectpoints = points[[1,2,4,3],:]
        xs = [pt[1] for pt in rectpoints];
        ys = [pt[2] for pt in rectpoints];
        seriestype := :shape
        color := :orange
        linecolor := :black
        #m = (:black, stroke(0))
        s = Shape(xs[:], ys[:])
    end

    @recipe function f(pt::Point)
        xs = [pt[1]]
        ys = [pt[2]]
        seriestype --> :scatter
        color := :orange
        markersize := 3
        xs, ys
    end
    
    @recipe function f(l::LineSegment)
        xs = [ l[1][1], l[2][1] ]
        ys = [ l[1][2], l[2][2] ]
        # seriestype = :line
        color := :darkblue
        lw := 3
        xs, ys
    end


    @recipe function f(rectList::Vector{<:HyperRectangle})
        for r in rectList
            @series begin
                r 
            end
        end
    end

    @recipe function f(ptList::Vector{<:Point})
        for p in ptList
            @series begin
                p
            end
        end
    end

    @recipe function f(lineList::Vector{<:LineSegment})
        for l in lineList 
            @series begin
                l 
            end
        end

    end 

    function plotRoom(room)
        aPlot = plot() #Todo! this assumes plotroom is first thing called()
        roomWidth, roomHeight, walls, obstacles = room.width, room.height, room.walls, room.obstacles
        plot!(aPlot, walls, color =:black)
        plot!(aPlot, obstacles, fillalpha=0.5)
        return aPlot
    end

    function plotRRT(roomPlot, graph, solPath, title)
        startstate, goalstate, nodeslist, edgeslist = graph.startstate, graph.goalstate, graph.nodeslist, graph.edgeslist

        x = [n.state[1] for n in nodeslist]
        y = [n.state[2] for n in nodeslist]
        scatter!(roomPlot, x,y, color=:black) 

        edgeXs, edgeYs = [], []
        for e in edgeslist
            startN = algfxn.findNode(e.startID, nodeslist)
            endN = algfxn.findNode(e.endID, nodeslist)
            x1,y1 = startN.state[1], startN.state[2]
            x2,y2 = endN.state[1], endN.state[2]
            push!(edgeXs, x1, x2, NaN) #the NaNs, keep spaces between edges correctly unplotted
            push!(edgeYs, y1, y2, NaN)
        end

        plot!(roomPlot, edgeXs, edgeYs, color=:tan, linewidth=1)

        rrtPlot = plotSolPath(roomPlot, solPath)
        
        title!(rrtPlot, title)
        plot!(rrtPlot, legend=false, size=(600,600), xaxis=((-2,22), 0:1:20 ), 
              yaxis=((-2,22), 0:1:20), foreground_color_grid= :black, titlefont=font("Arial", 10))


        return rrtPlot
    end

    function plotSolPath(aPlot, solPath)
        #print("\n ---Solution Path----- \n")
        if solPath != Void
            xPath = [n.state[1] for n in solPath] 
            yPath = [n.state[2] for n in solPath]
            xstart, ystart = solPath[1].state

            xend, yend = solPath[end].state
            scatter!(aPlot, [xstart], [ystart], 
                     markercolor= :red, markershape = :circle,  markersize = 6, markerstrokealpha = 0.5, markerstrokewidth=1)
            scatter!(aPlot, [xend], [yend], 
                     markerstrokecolor = :green, markershape = :dtriangle,  markersize = 5, markerstrokealpha = 1, markerstrokewidth=5)
            plot!(aPlot, xPath, yPath, color = :orchid, linewidth=3, fillalpha = 0.3)
        else
           # #print("\n --- No solution path found ----- \n")
        end

        return aPlot
    end

end

