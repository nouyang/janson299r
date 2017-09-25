print("Hello World! ☺ ♫ ☕ \n\n")

using Plots

clf()

#x = linspace(0,2*pi,1000); y = sin.(3*x + 4*cos.(2*x));
#plot(x, y, color="red", linewidth=2.0, linestyle="--")



function test()
	#figure;
	foo = rand(1)
	title("A rrt visualization $(foo)")

    dim = 6
    roomx = [0,0,dim,dim];
    roomy = [0,dim,dim,0];

    plot(roomx, roomy, color=:black, linewidth=5);

    axis("equal");
    fig = gcf();
    #set(gca,"XTick",-13:1:13)
    #set(gca,"YTick",-6:1:13)

    #a = array([0 1 2 3 4 5 6]) 
    #yticks(a)
    #ax = fig.gca()
    #ax.set_aspect("equal")

    # two obstacles
    obs1 = Obstacle((1,0),(2,1))
    obs2 = Obstacle((2,2),(3,3))
    circleObs(obs1)
    circleObs(obs2)

    startx, starty = (3,-1)
    goalx, goaly = (4,5)
    bigcircle = 0.3

	circle(startx, starty,0.5, :red)
	circle(goalx, goaly,0.5, :green)

	robotRad = 0.5
    rob = Node(0,0,(startx, starty)) #!
    
    rrt = rrtPath(Node[],Edge[])

## okay -- iterations
#    iterations = 3 
#    for k = 1:iterations
#        xy_rand = rand(0:dim)
#
#        newNode = Node(i, iprev, xy_rand)
#        if inCollision(newNode)
#            continue
#        end

#        newEdge = Edge(nodePrev, newNode)
#        if inCollision(newEdge):
#            continue
#        end


#        push!(rrt.nodeslist,newNode)
#        push!(rrt.edgeslist,newEdge)
#

#        addNode(rrt, 
    #end
##
    push!(rrt.nodeslist,rob)
    push!(rrt.nodeslist,rob)
    testgoal = Node(1,0,(goalx, goaly))
    push!(rrt.nodeslist,testgoal)

    line((1,1),(2,2), "red")

##

end


function main()
    #dostuff
    # Draw the walls
    # Apply circles to represent the obstacles
    # Set location of start and end goals
    ## ball radius, etc.
    ## safety margin around the ball, threshold for reaching end state,
    ## max # of iterations 
    room = Room(0,0,10,10);
    
    p_start = [0;11];
    p_goal = [0;-1];

    rob.ballradius = 0.5;
    rob.p = p_start;

    
    # Draw the start and the goal, with circles too!
    circle(rob.p(1,1),rob.p(2,1),rob.ballradius,'g');
    circle(p_goal(1,1),p_goal(2,1),rob.ballradius,'r');

    # Plan path
    P = PlanPathRRT(rob,obst,param,p_start,p_goal);

    # Plot the path
    for i=2:length(P)
        plot([P(1,i);P(1,i-1)],[P(2,i);P(2,i-1)],"g","LineWidth",3);
    end
    
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


module rrtTypes
    export Node, Edge

    struct Node
        id::Int
        iPrev::Int #parent
        state::Tuple{Int,Int}
        id2::Int
    end

    struct Edge
        startnode::Int
        endnode::Int
    end
end



type Obstacle
    SW
    NE
end


struct rrtPath
    nodeslist
    edgeslist
    #nodeslist::Array{Node}
    #edgeslist::Array{Edge}
end

















############################################################



### Some types?
struct Room #corners of the room
    x1::Int
    y1::Int #bottom left corner?
    x2::Int
    y2::Int
end
struct obstacle
    
end

struct robot
    
end
        
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

print("\n\nend of function. \n")

test()
