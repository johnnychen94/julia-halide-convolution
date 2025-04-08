using Test
using HLConv.C

@testset "Buffer" begin
    for T in (Float32, Float64)
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
        end

        @testset "2D $(T)" begin
            x = reshape(T[1.0, 2.0, 3.0, 4.0], (2, 2))
            x_buf = unsafe_wrap_buffer(x)

            @test x_buf.ptr != C_NULL
            @test ndims(x_buf) == 2
            @test size(x_buf) == (2, 2)
            @test eltype(x_buf) == T
            @test length(x_buf) == 4

            @test x_buf[1, 1] == T(1.0)
            @test x_buf[1, 2] == T(3.0)
            @test x_buf[2, 1] == T(2.0)
            @test x_buf[2, 2] == T(4.0)

            @test collect(x_buf) == x

            x_buf[1, 1] = T(10.0)
            @test x_buf[1, 1] == T(10.0)
            @test x[1, 1] == T(10.0)

            @test x_buf[2, 1] == T(2.0)
            @test x_buf[2, 2] == T(4.0)
        end
    end
end
