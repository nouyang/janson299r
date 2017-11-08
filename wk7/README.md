# wk8
END DATE: 11/21
Well. Tasks to do: 

Implement RRT

More PRM / RRT -> what I want to do: write up mini report, investigate
* clutter
* maze
* more dimensions woo
* error bars
bidirectional RRT? and other fun things Implement `RRT*` and `FMT*`

Read `RRT*`-> more proof magic?  Read `FMT*`

* May be useful to write down things I learned each week, at this point. (from
  the technical perspective)



## Timeline
Plan for final 5 weeks:
```
11/14 - (actually we'll meet 11/15) have read RRT*/FMT* papers, maybe not 100% as this task will bleed into next week
11/21 - have actually finished reading RRT*/FMT* papers and implemented RRT*/PRM*/FMT* in simulation
11/28 - have a few genuine experiments run and have tried some alterations to the algorithms (which we will have discussed last time)
12/5 - finish up any final things from the past few weeks and have outline and/or early draft of final report
12/12 - close-to-final draft of final report
```

# Todo
* Error bars
* Calculate area *within* the room, as opposed to removing rectangles that fall
outside the room at all. I do the latter currently which results in a lot of
paths going through the narrow extra spaces near the walls.

# Todo
plot one of each pClutter, together on a subplot,  directly within the clutterExp() code

doublecheck yerr takes in 1 stddev or 1/2 stddev to center around the mean

!!!! Plot start and end goals, even if fail to find path...
This should DEFINITELY be done.


Check if obstacle covers start or end goals...(can a path be found at all?)

Allow obstacles to be generated outside of room (just calculate contained area)


# To run
use 
`clutter_with_errorbars.jl`
and 
`walls_experiment.jl`
