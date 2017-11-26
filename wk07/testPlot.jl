using Plots
pyplot()

module boo
    using Plots
    function plotSomething(fooplot)
            z = rand(10)
            x = 1:10
            plot!(fooplot, x, z);
        return fooplot
    end
end


function main()
    fooplot = plot();
    x = 1:10
    y = rand(10)
    plot!(fooplot, x,y)
    plot1 = boo.plotSomething(fooplot);
    gui(plot1)
end

main()
