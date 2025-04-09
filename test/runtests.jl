using Test
using HLConv

@testset "HLConv" begin
	include("buffer.jl")

	@testset "Ops" begin
		include("ops/conv1d.jl")
	end
end
