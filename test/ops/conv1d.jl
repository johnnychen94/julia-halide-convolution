using Test
using HLConv

include("data.jl")

@testset "conv1d" begin
  @testset "conv1d" begin
    for T in HLTypesList
      @testset "$(T)" begin
        x = T[1, 2, 3, 4]
        y = T[2, 3, 4, 5]
        z = conv1d(x, y)

        @test length(z) == 7
        @test z == [2, 7, 16, 30, 34, 31, 20]
      end
    end

    @testset "generic array" begin
      x = [1, 2, 3, 4]
      xv = view(x, 1:3)
      y = [2, 3, 4, 5]
      yv = view(y, 1:3)

      z = conv1d(xv, yv)
      @test length(z) == 5
      @test z == [2, 7, 16, 17, 12]

      z = conv1d(1:3, 2:4)
      @test length(z) == 5
      @test z == [2, 7, 16, 17, 12]

      x = Any[1, 2, 3, 4]
      y = Real[2, 3, 4, 5]
      z = conv1d(x, y)
      @test length(z) == 7
      @test z == [2, 7, 16, 30, 34, 31, 20]

      x = Any[1, 2, 3, 4]
      y = Real[2, 3, 4, 5]
      z = Vector{Number}(undef, 7)
      conv1d!(z, x, y)
    end
  end

  @testset "conv1d!" begin
    for T in HLTypesList
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

@testset "matlab compatibility" begin
  for n in keys(data)
    x = data[n]["x"]
    y = data[n]["y"]
    z = data[n]["z"]
    @test conv1d(x, y) ≈ z
  end
end
