module BracketedTrees

import AbstractTrees: children

"""
    BracketedTrees.data(tree_node)

TODO docs
"""
data(x) = x
data(tree::AbstractVector) = nothing

include("read.jl")
include("write.jl")

end # module
