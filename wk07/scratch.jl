##  Conclusion: make my life easier and just define a GraphNode and a TreeNode

print("Hi!")
module tmp
    using GeometryTypes
    struct Node2
        id::Int
        iPrev::Int #parent
        state::Nullable{Point2f0}
    end

    #Node2(id::Int, iPrev::Int) = Node2(id, iPrev, Point2f0())
    Node2(id::Int, iPrev::Int) = Node2(id, iPrev, Point(999,999))
    # Node2(id::Int, iPrev::Int) = Node2(id, iPrev, Point())	
# 
	# Fails with;
	# WARNING: replacing module tmp
	# ERROR: LoadError: MethodError: Cannot `convert` an object of type Tuple{} to an object of type Float32
	# This may have arisen from a call to the constructor Float32(...),
	# since type constructors fall back to convert methods.

end

    x = tmp.Node2(1,2,Point(2,3))
    y = tmp.Node2(1,2)
