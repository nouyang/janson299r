using Plots
pyplot()

x = 1:10
y = rand(10)
plot(x,y)


n = 10
x = [rand()+1 * randn(n) + 2i for i in 1:5]
y = [rand()+1 * randn(n) + i for i in 1:5]

f(v) = 1.96std(v) / sqrt(n)
xerr = map(f,x)
yerr = map(f,y)
x = map(mean, x)
y = map(mean, y)

plot(x,y, xerr = xerr, yerr = yerr, marker=stroke(2, :orange))
