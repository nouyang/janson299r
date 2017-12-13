using Plots
gr()

x = 1:10; y = rand(10) # These are the plotting data
plot(x,y)

annotate!([(0,0,  text("this is #5\r\n asdf",16,:red,:center) ) ])

gui()
