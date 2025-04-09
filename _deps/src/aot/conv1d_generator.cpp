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

    Var k;

    void generate()
    {
        auto m = input.width();
        auto n = kernel.width();

        Func X_bound = BoundaryConditions::constant_exterior(input, cast<T>(0), {{0, m}});
        Func K_bound = BoundaryConditions::constant_exterior(kernel, cast<T>(0), {{0, n}});

        Func conv("conv");
        RDom j(0, m);

        // w(k) = sum over j of u(j) * v(k - j)
        conv(k) = cast<T>(0);
        conv(k) += X_bound(j) * K_bound(k - j);

        output(k) = conv(k);
    }
};

HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<double>, conv1d_f64_aot)
HALIDE_REGISTER_GENERATOR(Conv1DAOTGenerator<float>, conv1d_f32_aot)
