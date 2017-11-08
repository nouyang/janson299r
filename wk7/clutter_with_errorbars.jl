include("PRM.jl")
#using Distributions




#################################### 
# Randomly Generate Clutter (obstacles) 
####################################

# implement function to create clutter
# Let's say on average we want to create 4 obstacles... (otherwise, *most* of
# the time we will product one large rectangle that is falling out of the room

#targetNumObs = 2 
function genClutter(roomperimeter, param, targetNumObs, clutterPercentage, roomWidth, roomHeight)
    obstacles = Vector{HyperRectangle}()
    roomArea = roomWidth * roomHeight
    targetSumObsArea= roomArea * clutterPercentage
    sumObsArea = 0
    while sumObsArea < targetSumObsArea
        x,y = rand(Uniform(0, roomWidth),2)

        randWidth, randHeight = rand(Uniform(1, roomWidth/targetNumObs),2)
        #randWidth, randHeight = rand(1:roomWidth/targetNumObs,2)
        protoObstacle = HyperRectangle(Vec(x, y), Vec(randWidth, randHeight)) #Todo
        if contains(roomperimeter, protoObstacle)
            push!(obstacles, protoObstacle)
            sumObsArea += randWidth*randHeight
        end
    end
    actualSumObsArea = sumObsArea 
    #print("obstacles generated")
    return actualSumObsArea, obstacles
end
####



function testGenClutter()

    #################################### 
    ## PARAMETERS
    #################################### 
    numSamples = 100 
    connectRadius = 5
    param = algT.AlgParameters(numSamples, connectRadius)

    targetNumObs = 3
    clutterPercentage = 0.25
    roomWidth,roomHeight  = 20,20

    startstate = Point(1.,1)
    goalstate = Point(19.,19)

    #################################### 
    ## INIT
    #################################### 
    obstacles = Vector{HyperRectangle}()
    perimeter = HyperRectangle(Vec(0.,0), Vec(roomWidth,roomHeight))
    wallsPerimeter = algfxn.decompRect(perimeter)

    walls = Vector{LineSegment}()
    for l in wallsPerimeter
        push!(walls, l)
    end
    #plot!(walls, color =:black)
    #plot!(obstacles, fillalpha=0.5)



#################################### 
# Run PRM once and display config space plot  
####################################


    obsArea, obstacles = genClutter(perimeter, param, targetNumObs, clutterPercentage, roomWidth, roomHeight)
    r = algT.Room(roomWidth,roomHeight,walls,obstacles)
    roomPlot = plotfxn.plotRoom(r)

    ## Run preprocessing
    nodeslist, edgeslist = preprocessPRM(r, param)
    print("\n ---- pre-processed --- \n")

    ## Query created RM

    pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)
    print("\n ---- queried ---- \n")

    ## Plot path found
    timestamp = Base.Dates.now()
    title = "PRM with # samples=$numSamples, maxDist=$connectRadius, \npathcost = $pathcost, 
            timestamp=$timestamp)\n\n"
    roadmap = algT.roadmap(startstate, goalstate, nodeslist, edgeslist)


    #prmPlot= plotfxn.plotPRM(roomPlot, roadmap, solPath, title::String, afont)
    prmPlot= plotfxn.plotPRM(roomPlot, roadmap, solPath, title::String)

    print("\n --- Time --- \n")
    @show timestamp
    #print("\n --- Obstacles --- \n")
    #@show obstacles 
    #print("\n --- Nodes --- \n")
    #@show nodeslist 
    #print("\n --- Edges --- \n")
    #@show edgeslist 
    # print("\n -------- \n")

    f = Plots.Font(05,"Liberation Serif")
    plot!(prmPlot,titlefont = f)

    gui(prmPlot)
        print("\n --- Press ENTER to continue --- \n")
        #readline(STDIN)
        # todo: save one "representative" figure from each run
        # print("\n --- continue --- \n")
    @show  isPathFound

end






function clutterExp()
    #################################### 
    # Run multiple trials and scatterplot all cost vs area for all runs 
    # due to varying absolute area
    ####################################
    #################################### 
    ## PARAMETERS - RRT  
    #################################### 
    connectRadius = 8.
    numPts = 100.
    param = algT.AlgParameters(numPts, connectRadius)
    targetNumObs = 5 
    #clutterPercentage = 0.15
    roomWidth,roomHeight  = 20,20

    startstate = Point(1.,1)
    goalstate = Point(19.,19)

    ####################################
    ## PARAMETERS - plot clutter 
    ####################################
    N = 10

    clutterPercentages = [0 0.01 0.05 0.1 0.12 0.15 0.2 0.25 0.3 0.4 0.5]
    clutterPercentages = [0 0.1 0.2 0.3 0.5]
    #clutterPercentages = 0 : 0.05 :0.3

    ####################################
    ## Init
    ####################################
    listCosts = Vector{Float32}()
    listpSucc= Vector{Float32}()

    obstacles = Vector{HyperRectangle}()
    perimeter = HyperRectangle(Vec(0.,0), Vec(roomWidth,roomHeight))
    wallsPerimeter = algfxn.decompRect(perimeter)

    walls = Vector{LineSegment}()
    for l in wallsPerimeter
        push!(walls, l)
    end


    ####################################
    # Run Trials
    ####################################

    plot()
    tic()

    stddevs = Vector{Float64}()
    avgCosts = Vector{Float32}() #one per %clutter

    for pClutter in clutterPercentages
        idx, nSuccess, pathcost = 0,0,0.
        pathcosts = Vector{Float32}() #one per %clutter
        stddev = 0.

        param = algT.AlgParameters(numPts, connectRadius)
        print("\n ------ \n")

        while idx < N 
            idx += 1

            obstacles = Vector{HyperRectangle}()
            obsArea, obstacles = genClutter(perimeter, param, targetNumObs, pClutter, roomWidth, roomHeight)
            r = algT.Room(roomWidth,roomHeight,walls,obstacles)
            nodeslist, edgeslist = preprocessPRM(r, param)
            pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)

            if isPathFound
                nSuccess += 1
            end
            if !(pathcost == Void)
                push!(pathcosts, pathcost)
            end
        end

        totalcost = sum(pathcosts)
        avgCost = totalcost /  nSuccess # average cost across the nTrials 
        @show nSuccess
        pSucc = nSuccess / N 

        sumSqdError = sum([cost - avgCost for cost in pathcosts].^2)
        @show sumSqdError
        stddev = sqrt( sumSqdError / (nSuccess -1))

        #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
        push!(avgCosts, avgCost) #todo combine pt1
        push!(stddevs, stddev) #todo combine pt2
        push!(listpSucc, pSucc)
    end

    timeExperiment = toc();
    print("Time to run experiment: $timeExperiment\n")
    timestamp = Base.Dates.now()

    ####################################
    # Plot Results
    ####################################
    # clutter (area) on X
    # pathcost on Y
    sizeplot = (800,600)

    @show clutterPercentages
    @show avgCosts 
    @show stddevs
    @show listpSucc

    supTitle= ""
    # why does glvisualize() have terrible title() issues? oh well comment out for now
    # supTitle="\nPRM with maxDist=$connectRadius, 
            # # samples = $numSamples, nTrials=$nTrials.
            # (time to run:$timeExperiment, timestamp=$timestamp)\n\n"
    costTitle= "clutter % vs pathcost\n"

    yerrCost = 10
    print("type of stddevs, $(typeof(stddevs))")
    stddevs = stddevs'
    yerrCost = [0 1.0 2.1 5.1 10.0]
    print("type of yerrCost , $(typeof(yerrCost))")

    pPRMcost = scatter(clutterPercentages, avgCosts',
        markercolor = :black,
        title = supTitle * costTitle, ylabel = "euclidean path cost", xlabel = "clutter %",
        yaxis=((20,40), 0:5:40), yerr = stddevs)
         # yerr = yerrCost)

    successTitle = "\nclutter % vs pSuccess\n"
    pPRMsuccess = scatter(clutterPercentages, listpSucc',
        color = :orange, markersize= 6, 
        title = successTitle, ylabel = ("P(success)=numSucc/$N trials"), xlabel = "clutter %",
        yaxis=((0, 1.2), 0:0.1:1))

    plot(pPRMcost, pPRMsuccess, layout=(2,1), legend=false,
        xaxis=((-0.05, 0.6), 0:0.05:0.6),
        size = sizeplot)
end
#testGenClutter()

#testGenClutter()
clutterExp()
