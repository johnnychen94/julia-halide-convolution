module HLConv

module C
	include("libconv/libconv.jl")
	include("buffer.jl")

	using .LibBuffer
	export Buffer, unsafe_wrap_buffer
end

include("gradient.jl")
include("conv1d.jl")

export conv1d, conv1d!, gradient2d, gradient2d!

end # module
