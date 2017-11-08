print("Hello world. walls")

include("PRM.jl")
#using Distributions
glvisualize()

pfont = Plots.Font("sans-serif", 8, :left, :left, 0.0, RGB{U8}(0.0, 0.0, 0.0))
glvisualize(titlefont = pfont, guidefont = pfont)




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



function genTrapWalls()
    trapWalls = Vector{LineSegment}()
    lineL = LineSegment( Point(5,5), Point(5,10))
    lineR = LineSegment( Point(10,5), Point(10,10))
    #lineBot = LineSegment( Point(5,5), Point(10,5))
    lineTop = LineSegment( Point(5,10), Point(10,10))
    lineBotRight = LineSegment( Point(8,5), (10,5))
    lineBotLeft = LineSegment( Point(5,5), (7,5))
    push!(trapWalls, lineL, lineR, lineTop , lineBotLeft, lineBotRight) #opening at top
    startstate = (7,7) #start state inside the trap
    return startstate, trapWalls
end

function genTrapWalls(doorSize)
    trapWalls = Vector{LineSegment}()
    lineL = LineSegment( Point(5,5), Point(5,10))
    lineR = LineSegment( Point(10,5), Point(10,10))
    #lineBot = LineSegment( Point(5,5), Point(10,5))
    lineTop = LineSegment( Point(5,10), Point(10,10))
    lstop = 7.5 - (doorSize/2.0)
    rstart = lstop + doorSize

    lineBotRight = LineSegment( Point(rstart,5), (10,5))
    lineBotLeft = LineSegment( Point(5,5), (lstop,5))

    push!(trapWalls, lineL, lineR, lineTop , lineBotLeft, lineBotRight) #opening at top
    startstate = (7,7) #start state inside the trap
    return startstate, trapWalls
end

function testGenWalls()

    #################################### 
    ## PARAMETERS
    #################################### 
    numPts = 100 
    connectRadius = 10 
    param = algT.AlgParameters(numPts, connectRadius)

    targetNumObs = 3
    clutterPercentage = 0.1
    roomWidth,roomHeight  = 20,20

    startstate = Point(7.,7)
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

    #lineLeftTop = LineSegment( Point(5,10), Point(7,10))
    #lineRightTop = LineSegment( Point(8,10), Point(10,10))

    #push!(walls, lineL, lineR, lineBot, lineLeftTop, lineRightTop) #opening at bottom
    push!(walls, lineL, lineR, lineTop , lineBotLeft, lineBotRight) #opening at top

    #plot!(walls, color =:black)
    #plot!(obstacles, fillalpha=0.5)


    obsArea, obstacles = genClutter(perimeter, param, targetNumObs, clutterPercentage, roomWidth, roomHeight)

#################################### 
# Run PRM once and display config space plot  
####################################


    #obsArea, obstacles = genClutter(perimeter, param, targetNumObs, clutterPercentage, roomWidth, roomHeight)
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
    title = "PRM with numPts =$numPts, maxDist=$connectRadius, \npathcost = $pathcost, 
            timestamp=$timestamp)\n\n"
    roadmap = algT.roadmap(startstate, goalstate, nodeslist, edgeslist)


    #prmPlot= plotfxn.plotPRM(roomPlot, roadmap, solPath, title::String, afont)
    prmPlot= plotfxn.plotPRM(roomPlot, roadmap, solPath, title::String)
    plot!(prmPlot, size=(900,600))

    print("\n --- Time --- \n")
    @show timestamp
    #print("\n --- Obstacles --- \n")
    #@show obstacles 
    #print("\n --- Nodes --- \n")
    #@show nodeslist 
    #print("\n --- Edges --- \n")
    #@show edgeslist 
    # print("\n -------- \n")


    gui(prmPlot)
        print("\n --- Press ENTER to continue --- \n")
        #readline(STDIN)
        # todo: save one "representative" figure from each run
        # print("\n --- continue --- \n")
    @show  isPathFound

end




function walls_vs_nSamples()
    #################################### 
    # Run multiple trials and scatterplot all cost vs area for all runs 
    # due to varying absolute area
    ####################################
    #################################### 
    ## PARAMETERS - RRT  
    #################################### 
    connectRadius = 8.
    numPts = 0.
    param = algT.AlgParameters(numPts, connectRadius)
    targetNumObs = 5 
    percentClutter = 0.15
    roomWidth,roomHeight  = 20,20

    startstate, trapwalls = genTrapWalls() #bugtrap walls
    goalstate = Point(19.,19)

    ####################################
    ## PARAMETERS - plot clutter 
    ####################################
    N = 30 

    #clutterPercentages = [0 0.01 0.05 0.1 0.12 0.15 0.2 0.25 0.3 0.4 0.5]
    #clutterPercentages = [0 0.1 0.2 0.3 0.5]

    numPtsList = [10 20 30 80 100]

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
    for l in trapwalls
        push!(walls, l)
    end

    ####################################
    # Run Trials
    ####################################

    plot()
    tic()

    stddevs = Vector{Float64}()
    avgCosts = Vector{Float32}() #one per %clutter

    print("\n ------ \n")
    for numPts in numPtsList 
        idx, nSuccess, pathcost = 0,0,0.
        pathcosts = Vector{Float32}() #one per %clutter
        stddev_n = 0.

        param = algT.AlgParameters(numPts, connectRadius)

        while idx < N 
            idx += 1
            obstacles = Vector{HyperRectangle}()
            obsArea, obstacles = genClutter(perimeter, param, targetNumObs, percentClutter, roomWidth, roomHeight)
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
        #@show nSuccess
        pSucc = nSuccess / N 

        sumSqdError = sum([cost - avgCost for cost in pathcosts].^2)
        #@show sumSqdError
        #@show pathcosts
        #@show avgCost
        stddev_n = sqrt( sumSqdError / (nSuccess -1))
        #@show stddev_n

        #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
        push!(avgCosts, avgCost) #todo combine pt1
        push!(stddevs, stddev_n) #todo combine pt2
        push!(listpSucc, pSucc)
        print("\n ------ \n")
    end

    timeExperiment = toc();
    print("Time to run experiment: $timeExperiment\n")
    timestamp = Base.Dates.now()

    ####################################
    # Plot Results
    ####################################
    # clutter (area) on X
    # pathcost on Y
    sizeplot = (800,800)

    supTitle="TRAP prm with maxdist=$connectRadius, "*  "Avgd across #samples = $N" *
            "\n(time to run:$(ceil(timeExperiment, 2)) "*
            "\ntimestamp=$timestamp)"
    costTitle= "\nnumPts% vs pathcost\n"


    stddevs = stddevs' #why is this needed for the errors to plot correctly (not constant error)?

    pPRMcost = scatter(numPtsList, avgCosts',
        markercolor = :black,
        title = supTitle * costTitle, ylabel = "euclidean path cost", xlabel = "numPts", 
        yaxis=((0,50), 0:5:40), yerr = stddevs) #this automatically centers the 1 stddev, I think. So each side is +- 0.5 stddev?
         # yerr = yerrCost)

    successTitle = "numPts vs pSuccess"
    pPRMsuccess = scatter(numPtsList, listpSucc',
        color = :orange, markersize= 6, 
        title = successTitle, title_location=:center, ylabel = ("P(success)=numSucc/$N trials"), xlabel = "numPts",
        yaxis=((0, 1.2), 0:0.1:1))

    plot(pPRMcost, pPRMsuccess, layout=(2,1), legend=false,
         xaxis=((0,320), 0:50:300),
        size = sizeplot)
end




function doorSize_vs_pathCost()
    #################################### 
    # Run multiple trials and scatterplot all cost vs area for all runs 
    # due to varying absolute area
    ####################################
    #################################### 
    ## PARAMETERS - RRT  
    #################################### 
    connectRadius = 4.
    numPts = 100.
    param = algT.AlgParameters(numPts, connectRadius)
    targetNumObs = 4 
    percentClutter = 0.1
    roomWidth,roomHeight  = 20,20

    goalstate = Point(19.,19)

    ####################################
    ## PARAMETERS - plot clutter 
    ####################################
    N = 80 

    #clutterPercentages = [0 0.01 0.05 0.1 0.12 0.15 0.2 0.25 0.3 0.4 0.5]
    #clutterPercentages = [0 0.1 0.2 0.3 0.5]

    #numPtsList = [10 20 30 80 100]
    doorSizes = [ 0.2 0.5 0.7 1 1.5 2 2.5 3 3.5 4 4.5 4.8]
    #doorSizes = [0.5 1 2 3 4 4.5]
    #doorSizes = [1]

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

    print("\n ------ \n")
    for doorSize in doorSizes 

        obstacles = Vector{HyperRectangle}()
        perimeter = HyperRectangle(Vec(0.,0), Vec(roomWidth,roomHeight))
        wallsPerimeter = algfxn.decompRect(perimeter)

        walls = Vector{LineSegment}()
        startstate,trapwalls = genTrapWalls(doorSize)

        for l in wallsPerimeter
            push!(walls, l)
        end
        for l in trapwalls
            push!(walls, l)
        end

        idx, nSuccess, pathcost = 0,0,0.
        pathcosts = Vector{Float32}() #one per %clutter
        stddev_n = 0.

        param = algT.AlgParameters(numPts, connectRadius)

        while idx < N 
            idx += 1
            obstacles = Vector{HyperRectangle}()
            obsArea, obstacles = genClutter(perimeter, param, targetNumObs, percentClutter, roomWidth, roomHeight)
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
        #@show nSuccess
        pSucc = nSuccess / N 

        sumSqdError = sum([cost - avgCost for cost in pathcosts].^2)
        #@show sumSqdError
        #@show pathcosts
        #@show avgCost
        stddev_n = sqrt( sumSqdError / (nSuccess -1))
        #@show stddev_n

        #@printf("For the iter of %d the avg cost was %d across %d trials", maxIter, avgCost, nTrials)
        push!(avgCosts, avgCost) #todo combine pt1
        push!(stddevs, stddev_n) #todo combine pt2
        push!(listpSucc, pSucc)
        print("\n ------ \n")
    end

    timeExperiment = toc();
    print("Time to run experiment: $timeExperiment\n")
    timestamp = Base.Dates.now()

    ####################################
    # Plot Results
    ####################################
    # clutter (area) on X
    # pathcost on Y
    sizeplot = (600,800)

    supTitle="TRAP prm with numPts=$numPts, maxdist=$connectRadius, 
    targetNumObs=$targetNumObs, percentClutter=$percentClutter, 
    Avgd across #samples = $N, \n(time to run:$(ceil(timeExperiment, 2)) secs "*
            "timestamp=$timestamp)"


    costTitle= "\ndoorSizes vs pathcost\n"


    stddevs = stddevs' #why is this needed for the errors to plot correctly (not constant error)?

    pPRMcost = scatter(doorSizes, avgCosts',
        markercolor = :black,
        title = supTitle * costTitle, ylabel = "euclidean path cost", xlabel = "doorSizes", 
        yaxis=((20,50), 20:5:40), yerr = stddevs) #this automatically centers the 1 stddev, I think. So each side is +- 0.5 stddev?
         # yerr = yerrCost)

    successTitle = "doorSizes vs pSuccess"
    pPRMsuccess = scatter(doorSizes, listpSucc',
        color = :orange, markersize= 6, 
        title = successTitle, title_location=:center, ylabel = ("P(success)=numSucc/$N trials"), xlabel = "doorSizes",
        yaxis=((0, 1.2), 0:0.1:1))

    plot(pPRMcost, pPRMsuccess, layout=(2,1), legend=false,
         xaxis=((0,5), 0:0.5:5),
        size = sizeplot)
end

function plotDoorSize()
    #################################### 
    ## PARAMETERS - RRT  
    #################################### 
    connectRadius = 8.
    numPts = 100.
    param = algT.AlgParameters(numPts, connectRadius)
    targetNumObs = 3 
    percentClutter = 0.1
    roomWidth,roomHeight  = 20,20

    goalstate = Point(19.,19)
    doorSize = 4
    #################################### 
    ## PARAMETERS -INIT 
    #################################### 


        obstacles = Vector{HyperRectangle}()
        perimeter = HyperRectangle(Vec(0.,0), Vec(roomWidth,roomHeight))
        wallsPerimeter = algfxn.decompRect(perimeter)

        walls = Vector{LineSegment}()
        startstate,trapwalls = genTrapWalls(doorSize)

        for l in wallsPerimeter
            push!(walls, l)
        end
        for l in trapwalls
            push!(walls, l)
        end

        idx, nSuccess, pathcost = 0,0,0.
        pathcosts = Vector{Float32}() #one per %clutter
        stddev_n = 0.

        param = algT.AlgParameters(numPts, connectRadius)
        obstacles = Vector{HyperRectangle}()
        obsArea, obstacles = genClutter(perimeter, param, targetNumObs, percentClutter, roomWidth, roomHeight)
        r = algT.Room(roomWidth,roomHeight,walls,obstacles)
    roomPlot = plotfxn.plotRoom(r)


        nodeslist, edgeslist = preprocessPRM(r, param)
        pathcost, isPathFound, solPath = queryPRM(startstate, goalstate, nodeslist, edgeslist, obstacles)

    ## Plot path found
    timestamp = Base.Dates.now()
    title = "PRM with #doorsize=$doorSize, samples=$numPts, maxDist=$connectRadius, 
    pathcost = $(round(pathcost,2)), targetNumObs=$targetNumObs, percentClutter=$percentClutter, \ntimestamp=$timestamp)\n"
    targetNumObs = 3 
    percentClutter = 0.1
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

    #f = Plots.Font(05,"Liberation Serif")
    #plot!(prmPlot,titlefont = f)

    gui(prmPlot)
        print("\n --- Press ENTER to continue --- \n")
        #readline(STDIN)
        # todo: save one "representative" figure from each run
        # print("\n --- continue --- \n")
    @show  isPathFound
end

#walls_vs_nSamples()
doorSize_vs_pathCost()


#plotDoorSize()
