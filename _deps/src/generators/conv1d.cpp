#include <iostream>
#include "Halide.h"

#include "common.h"

using namespace Halide;

template <typename T>
class Conv1DAOTGenerator : public Halide::Generator<Conv1DAOTGenerator<T>>
{
public:
    GeneratorInput<Buffer<T, 1>> input{"input"};
    GeneratorInput<Buffer<T, 1>> kernel{"kernel"};
    GeneratorOutput<Buffer<T, 1>> output{"output"};

    Var k, ko, ki, kio, kii;
    RDom r;
    Func conv{"conv"}, input_bounded, kernel_bounded;
    Expr out_size;

    void generate()
    {
        auto m = input.width();
        auto n = kernel.width();
        out_size = m + n - 1;

        r = RDom(0, n);

        input_bounded = BoundaryConditions::constant_exterior(input, cast<T>(0));
        kernel_bounded = BoundaryConditions::constant_exterior(kernel, cast<T>(0));

        conv(k) = cast<T>(0);
        conv(k) += kernel_bounded(r) * input_bounded(k - r);

        output(k) = conv(k);
    }

    void schedule()
    {
        Target target = this->get_target();
        const bool has_avx2 = target.has_feature(Target::AVX2);
        const int vector_size = this->natural_vector_size(type_of<T>());

#if AOT_VERBOSE
        std::cout << "Target: " << target.to_string() << std::endl;
        std::cout << "Vector size: " << vector_size << std::endl;
#endif

        const int outer_tile = 1024;
        const int inner_tile = 32;

        Expr can_parallel = out_size >= outer_tile;
        Expr can_vectorize = out_size >= inner_tile;

        input_bounded.compute_root();
        kernel_bounded.compute_root();

        // First specialization: parallelizable
        output.specialize(can_parallel)
            .split(k, ko, ki, outer_tile)
            .parallel(ko)
            .split(ki, kio, kii, inner_tile)
            .vectorize(kii, vector_size);

        // Second specialization: small vectorizable loop
        output.specialize(can_vectorize)
            .split(k, kio, kii, inner_tile)
            .vectorize(kii, vector_size);

        // Fallback: no vectorization
        output.split(k, kio, kii, 1);

        // Compute conv at inner tile for better locality
        conv.compute_at(output, kio);

        // Schedule update of conv
        if (has_avx2)
        {
            RVar ro, ri, z;
            conv.update()
                .split(r, ro, ri, 8)
                .reorder(k, ri, ro)
                .vectorize(k, vector_size)
                .fuse(ri, k, z)
                .unroll(z);
        }
        else
        {
            conv.update()
                .vectorize(k, vector_size)
                .unroll(r, 4);
        }
    }
};

// Register the generator
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<int8_t>, aot_conv1d_i8)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<int16_t>, aot_conv1d_i16)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<int32_t>, aot_conv1d_i32)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<int64_t>, aot_conv1d_i64)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<uint8_t>, aot_conv1d_u8)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<uint16_t>, aot_conv1d_u16)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<uint32_t>, aot_conv1d_u32)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<uint64_t>, aot_conv1d_u64)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<float32_t>, aot_conv1d_f32)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<float64_t>, aot_conv1d_f64)
