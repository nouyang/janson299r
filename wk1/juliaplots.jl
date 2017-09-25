using Plots, Iterators
gr()

x = 1:10; y = rand(10,2) # 2 columns means two lines
plotly() # Set the backend to Plotly
plot(x,y,title="This is Plotted using Plotly") # This plots into the web browser via Plotly
gr() # Set the backend to GR
plot(x,y,title="This is Plotted using GR") # This plots using GR

p1 = plot(x,y) # Make a line plot
p2 = scatter(x,y) # Make a scatter plot
p3 = plot(x,y,xlabel="This one is labelled",lw=3,title="Subtitle")
p4 = histogram(x,y) # Four histograms each with 10 points? Why not!
plot(p1,p2,p3,p4,layout=(2,2),legend=false)
