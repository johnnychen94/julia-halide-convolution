using Test
using HLConv

@testset "conv1d" begin
	for T in [Float32, Float64]
		@testset "$(T)" begin
			x = T[1, 2, 3, 4]
			y = T[2, 3, 4, 5]
			z = conv1d(x, y)

			@test length(z) == 7
			@test z == [2, 7, 16, 30, 34, 31, 20]
		end
	end
end
