using Plots
pyplot()

sizeplot = (800, 800)

rand = randn()

supTitle="\nPRM with connection radius = $connectRadius\n\n"

costTitle= "numsamples vs pathcost\n"
pPRMcost = scatter(nSamples_list, listCosts, 
    color=:black,
    title = supTitle * costTitle, ylabel = "euclidean path cost", xlabel = "numsamples",
    xaxis=((0, 300), 0:50:300),
    yaxis=((0,100), 0:20:100))

successTitle = "\nnumsamples vs pSuccess\n"
pPRMsuccess = scatter(nSamples_list, listpSucc,
    #legend=false, yaxis=((0,1.1), 0:0.1:1), xaxis=((0,maxX+20), 0:50:maxX), color = :orange, markersize= 6)
    color = :orange, markersize= 6, 
    ylabel = ("P(success) = numSucc/$nTrials trials"), xlabel = "numsamples",
    xaxis=((0, 300), 0:50:300),
    yaxis=((0,1), 0:0.1:1), 
    title = successTitle)

plot(pPRMcost, pPRMsuccess, layout=(2,1), window_title="$rand PRM with connection radius = $connectRadius", size = sizeplot, 
     #legend=false, xaxis=((0, maxX+50), 0:50:maxX))
    )

