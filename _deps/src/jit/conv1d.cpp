#include "Halide.h"
#include <iostream>
#include "buffer.h"

using namespace Halide;

template <typename T>
int _conv1d(Buffer<T> out, Buffer<T> X, Buffer<T> K)
{
    Var x("x");

    int m = X.width(); // length of u
    int n = K.width(); // length of v

    Func X_bound = BoundaryConditions::constant_exterior(X, cast<T>(0), {{0, m}});
    Func K_bound = BoundaryConditions::constant_exterior(K, cast<T>(0), {{0, n}});

    Func conv("conv");

    RDom r(0, m); // loop over j

    // w(k) = sum over j of u(j) * v(k - j)
    conv(x) = cast<T>(0);
    conv(x) += X_bound(r) * K_bound(x - r);

    // realize size m + n - 1
    conv.realize(out);

    return 0;
}

extern "C"
{

    int conv1d_f64(CBuffer *output, CBuffer *X, CBuffer *kernel)
    {
        if (!output || !X || !kernel)
        {
            std::cerr << "Null pointer passed to conv1d." << std::endl;
            return 1;
        }

        Halide::Buffer<double> *out_buf = reinterpret_cast<Halide::Buffer<double> *>(output);
        Halide::Buffer<double> *X_buf = reinterpret_cast<Halide::Buffer<double> *>(X);
        Halide::Buffer<double> *kernel_buf = reinterpret_cast<Halide::Buffer<double> *>(kernel);

        return _conv1d(*out_buf, *X_buf, *kernel_buf);
    }

    int conv1d_f32(CBuffer *output, CBuffer *X, CBuffer *kernel)
    {
        if (!output || !X || !kernel)
        {
            std::cerr << "Null pointer passed to conv1d." << std::endl;
            return 1;
        }

        Halide::Buffer<float> *out_buf = reinterpret_cast<Halide::Buffer<float> *>(output);
        Halide::Buffer<float> *X_buf = reinterpret_cast<Halide::Buffer<float> *>(X);
        Halide::Buffer<float> *kernel_buf = reinterpret_cast<Halide::Buffer<float> *>(kernel);

        return _conv1d(*out_buf, *X_buf, *kernel_buf);
    }

} // extern "C"
