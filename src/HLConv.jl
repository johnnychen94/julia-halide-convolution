module HLConv

include("c/libconv.jl")

using .libconv

include("utils.jl")
include("buffer.jl")
include("conv1d.jl")

export conv1d, conv1d!

end # module
