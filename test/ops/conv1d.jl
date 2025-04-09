using Test
using HLConv

@testset "conv1d_jit" begin
	for T in [Float32, Float64]
		@testset "$(T)" begin
			x = T[1, 2, 3, 4]
			y = T[2, 3, 4, 5]
			z = conv1d(x, y)

			@test length(z) == 7
			@test z == [2, 7, 16, 30, 34, 31, 20]
		end
	end

	@testset "inplace" begin
		for T in [Float32, Float64]
			@testset "$(T)" begin
				x = T[1, 2, 3, 4]
				y = T[2, 3, 4, 5]
				z = similar(x, length(x) + length(y) - 1)
				conv1d!(z, x, y)

				@test length(z) == 7
				@test z == [2, 7, 16, 30, 34, 31, 20]
			end
		end
	end
end

@testset "conv1d_aot" begin
	for T in [Float32, Float64]
		@testset "$(T)" begin
			x = T[1, 2, 3, 4]
			y = T[2, 3, 4, 5]
			z = conv1d_aot(x, y)

			@test length(z) == 7
			@test z == [2, 7, 16, 30, 34, 31, 20]
		end
	end

	@testset "inplace" begin
		for T in [Float32, Float64]
			@testset "$(T)" begin
				x = T[1, 2, 3, 4]
				y = T[2, 3, 4, 5]
				z = similar(x, length(x) + length(y) - 1)
				conv1d_aot!(z, x, y)

				@test length(z) == 7
				@test z == [2, 7, 16, 30, 34, 31, 20]
			end
		end
	end
end
