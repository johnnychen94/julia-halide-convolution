module HLConv

module C
	include("libconv/libconv.jl")
	include("buffer.jl")

	using .LibBuffer
	export Buffer, unsafe_wrap_buffer
end

include("utils.jl")
include("gradient.jl")
include("conv1d_jit.jl")
include("conv1d_aot.jl")

export conv1d, conv1d!, conv1d_aot, conv1d_aot!, gradient2d, gradient2d!

end # module
