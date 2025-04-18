using Test
using HLConv
using HLConv: Buffer, unsafe_wrap_buffer

const HLTypesList = (
  UInt8, UInt16, UInt32, UInt64, Int8, Int16, Int32, Int64, Float32, Float64
)

@testset "Buffer" begin
  @testset "GC-ok" begin
    x = Buffer(4)
    @test x.ptr != C_NULL

    # test that the real data is not GC-ed
    GC.gc()
    x[1] = 1.0
    @test true

    f(n) = collect(Buffer(n))
    x = f(4)
    GC.gc()
    x[1] = 1.0

    g(A) = A
    x = g(Buffer(4))
    GC.gc()
    x[1] = 1.0
  end

  for T in HLTypesList
    @testset "1D $(T)" begin
      x = T[1.0, 2.0, 3.0, 4.0]
      x_buf = unsafe_wrap_buffer(x)

      @test x_buf.ptr != C_NULL
      @test ndims(x_buf) == 1
      @test size(x_buf) == (4,)
      @test eltype(x_buf) == T
      @test length(x_buf) == 4

      @test x_buf[1] == T(1.0)
      @test x_buf[2] == T(2.0)
      @test x_buf[3] == T(3.0)
      @test x_buf[4] == T(4.0)

      @test collect(x_buf) == x

      x_buf[1] = T(10.0)
      @test x_buf[1] == T(10.0)
      @test x[1] == T(10.0)
      @test x_buf[2] == T(2.0)
      @test x_buf[3] == T(3.0)
      @test x_buf[4] == T(4.0)

      x = Buffer{T}(4)
      @test x.ptr != C_NULL
      @test ndims(x) == 1
      @test size(x) == (4,)
      @test eltype(x) == T
      @test length(x) == 4
    end

    @testset "2D $(T)" begin
      x = T[1 2 3 4; 5 6 7 8]
      x_buf = unsafe_wrap_buffer(x)

      @test x_buf.ptr != C_NULL
      @test ndims(x_buf) == 2
      @test size(x_buf) == (2, 4)
      @test eltype(x_buf) == T
      @test length(x_buf) == 8
      @test collect(x_buf) == T[1 2 3 4; 5 6 7 8]

      x_buf[1, 1] = T(10.0)
      @test x_buf[1, 1] == T(10.0)
      @test x[1, 1] == T(10.0)
      @test collect(x_buf) == x == T[10 2 3 4; 5 6 7 8]

      x = Buffer{T}((2, 2))
      @test x.ptr != C_NULL
      @test ndims(x) == 2
      @test size(x) == (2, 2)
      @test eltype(x) == T
      @test length(x) == 4
    end
  end
end
