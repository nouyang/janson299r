using Plots, Iterators
gr()

function circle(x,y,r,c_color, myplot)
    th = 0:pi/50:2*pi;
    xunit = r * cos.(th) + x;
    yunit = r * sin.(th) + y;
    plot!(myplot, xunit, yunit,color=c_color,linewidth=3.0);
end



plt = plot()
circle(5,5, 5,:green);


function circleObs(obstacle)
    x1, y1 = obstacle.SW
    x2,y2 = obstacle.NE
    r = 0.2
    obsColor =  :black

    circle(x1,y1,r,obsColor)
    circle(x1,y2,r,obsColor)
    circle(x2,y1,r,obsColor)
    circle(x2,y2,r,obsColor)
end

obs1 = Obstacle((1,0),(2,1))
obs1 = Obstacle((1,0),(2,1))

circleObs(obs1)

############
print("\n\nend of function. \n")

module plotHelpers
    function line(startpt, finishpt, l_color)
        x1,y1 = startpt
        x2,y2 = finishpt
        plot([x1, x2], [y1,y2], color=l_color, linewidth=2)
    end

    function goalline(startpt, finishpt)
        x1,y1 = startpt
        x2,y2 = finishpt
        plot([x1, x2], [y1,y2], color="g", linewidth=2)
    end

    ### Some helper functions
    function circle(x,y,r,c_color)
        th = 0:pi/50:2*pi;
        xunit = r * cos.(th) + x;
        yunit = r * sin.(th) + y;
        h = plot(xunit, yunit,color=c_color,linewidth=3.0);
    end


    function circleObs(obstacle)
        x1, y1 = obstacle.SW
        x2,y2 = obstacle.NE
        r = 0.2
        obsColor =  :black

        circle(x1,y1,r,obsColor)
        circle(x1,y2,r,obsColor)
        circle(x2,y1,r,obsColor)
        circle(x2,y2,r,obsColor)
    end

end


###########


############################################################

#foo = Node(0,10,(1,2))
#print(foo, "\n Type ", typeof(foo))

function inCollisionObstacle(rob,obstacle)
end


function planPath(start, goal, ballradius, maxiters)
end

function AddNode(rrt, id, iPrev)
end

function inCollision(newPoint)
end

function inCollision(Node)
end
    
function distance()
end
    
function nn() #nearest neighbors
end
# robotRad = 0.5
# rob = Node(0,0,(startx, starty)) #!
# 
# rrt = rrtPath(Node[],Edge[])
# 
# ## okay -- iterations
# #    iterations = 3 
# #    for k = 1:iterations
# #        xy_rand = rand(0:dim)
# #
# #        newNode = Node(i, iprev, xy_rand)
# #        if inCollision(newNode)
# #            continue
# #        end
# # #        newEdge = Edge(nodePrev, newNode)




# robotRad = 0.5
# rob = Node(0,0,(startx, starty)) #!
# 
# rrt = rrtPath(Node[],Edge[])
# 
# ## okay -- iterations
# #    iterations = 3 
# #    for k = 1:iterations
# #        xy_rand = rand(0:dim)
# #
# #        newNode = Node(i, iprev, xy_rand)
# #        if inCollision(newNode)
# #            continue
# #        end
# 
# #        newEdge = Edge(nodePrev, newNode)
# #        if inCollision(newEdge):
# #            continue
# #        end
# 
# 
# #        push!(rrt.nodeslist,newNode)
# #        push!(rrt.edgeslist,newEdge)
# #
# 
# #        addNode(rrt, 
# #end
# ##
# push!(rrt.nodeslist,rob)
# push!(rrt.nodeslist,rob)
# testgoal = Node(1,0,(goalx, goaly))
# push!(rrt.nodeslist,testgoal)
# 
    # line((1,1),(2,2), "red")
# 
# ##
# 
# #        if inCollision(newEdge):
# #            continue
# #        end
# 
# 
# #        push!(rrt.nodeslist,newNode)
# #        push!(rrt.edgeslist,newEdge)
# #
# 
# #        addNode(rrt, 
# #end
# ##
# push!(rrt.nodeslist,rob)
# push!(rrt.nodeslist,rob)
# testgoal = Node(1,0,(goalx, goaly))
# push!(rrt.nodeslist,testgoal)
# 
    # line((1,1),(2,2), "red")
# 
# ##
# 



function plotRRT(room, paths)
    foo = rand(1)
    title("A rrt visualization $(foo)")

    dim = 6
    roomx = [0,0,dim,dim];
    roomy = [0,dim,dim,0];
    plot!(roomx, roomy, color=:black, linewidth=5)
    fig = gcf();

    # Plot the path
    for i=2:length(P)
        plot([P(1,i);P(1,i-1)],[P(2,i);P(2,i-1)],"g","LineWidth",3);
    end
end


module rrtFunctions
    struct rrtPath
        nodeslist
        edgeslist
        #nodeslist::Array{Node}
        #edgeslist::Array{Edge}
    end
end
