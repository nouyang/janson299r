using Plots

x = 1:10; y = rand(10) # These are the plotting data
plot(x,y)

x = 1:10; y = rand(10,2) # 2 columns means two lines
#plot!(x,y)
plot!(twinx(),y)

gui()
