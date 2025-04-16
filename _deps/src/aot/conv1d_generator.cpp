#include "Halide.h"
#include <iostream>

using namespace Halide;

template <typename T>
class Conv1DAOTGenerator : public Halide::Generator<Conv1DAOTGenerator<T>>
{
public:
    GeneratorInput<Buffer<T, 1>> input{"input"};
    GeneratorInput<Buffer<T, 1>> kernel{"kernel"};
    GeneratorOutput<Buffer<T, 1>> output{"output"};

    void generate()
    {
        auto m = input.width();
        auto n = kernel.width();
        auto out_size = m + n - 1;

        Var k;

        Func conv("conv");

        Func input_bounded = BoundaryConditions::constant_exterior(input, cast<T>(0));
        Func kernel_bounded = BoundaryConditions::constant_exterior(kernel, cast<T>(0));

        // Use a fixed-size reduction domain over the kernel size
        RDom r(0, n);

        // Initialize to zero
        conv(k) = cast<T>(0);

        conv(k) += kernel_bounded(r) * input_bounded(k - r);
        output(k) = conv(k);

        // Schedule
        Var ko, ki, kio, kii;

        // Check if the target has AVX2 or better
        Target target = this->get_target();
        const bool has_avx2 = target.has_feature(Target::AVX2);
        const int vector_size = this->natural_vector_size(type_of<T>());

        std::cout << "Target: " << target.to_string() << std::endl;
        std::cout << "Vector size: " << vector_size << std::endl;

        input_bounded.compute_root();
        kernel_bounded.compute_root();

        // Choose better tile sizes based on register count and vector width
        // These tile sizes are chosen to maximize register usage
        const int outer_tile = 1024; // Large outer tile for parallelism
        const int inner_tile = 32;   // Small inner tile to fit in L1 cache

        auto can_parallel = out_size >= outer_tile;
        auto can_vectorize = out_size >= inner_tile;

        // Our strategy is to have smaller inner tiles that fit in L1 cache
        // but larger outer tiles for efficient parallelism
        output.specialize(can_parallel)
            .split(k, ko, ki, outer_tile)    // Split into outer tiles for parallelism
            .parallel(ko)                    // Parallelize the outer loop
            .split(ki, kio, kii, inner_tile) // Further split inner loop for vectorization
            .vectorize(kii, vector_size)     // Vectorize the innermost loop
            .unroll(kio, 2);                 // Unroll the middle loop for instruction-level parallelism

        output.specialize(can_vectorize)
            .split(k, kio, kii, inner_tile)
            .vectorize(kii, vector_size)
            .unroll(kio, 2);

        // fallback for small size
        output.split(k, kio, kii, 1);

        // Compute the convolution at the inner tile level for better locality
        // This helps ensure the data used by the computation fits in L1 cache
        conv.compute_at(output, kio);

        // Enhanced update schedule for modern CPUs
        if (has_avx2)
        {
            // Split the reduction domain for better locality
            RVar ro, ri;

            // Split the reduction variable for better memory access patterns
            conv.update()
                .split(r, ro, ri, 16)      // Split the reduction domain
                .reorder(ri, k, ro)        // Reorder to improve locality
                .vectorize(k, vector_size) // Vectorize the output dimension
                .unroll(ri, 4)             // Unroll the inner reduction loop
                .unroll(k, 2);             // Further unroll output for more ILP
        }
        else
        {
            // For non-AVX2 targets, still optimize but less aggressively
            conv.update()
                .vectorize(k, vector_size)
                .unroll(r, 4);
        }
    }
};

HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<double>, conv1d_f64_aot)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<float>, conv1d_f32_aot)
