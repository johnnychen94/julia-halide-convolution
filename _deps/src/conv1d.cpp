// #include "Halide.h"
// #include <iostream>
// #include "buffer.h"

// using namespace Halide;

// template <typename T>
// int _conv1d(Halide::Buffer<T> output, Halide::Buffer<T> X, Halide::Buffer<T> kernel) {
//     // Check that X and kernel are one-dimensional.
//     if (X.dimensions() != 1 || kernel.dimensions() != 1) {
//         return 1;
//     }

//     // Get the size of X and kernel.
//     int X_size = X.width();
//     int kernel_size = kernel.width();

//     // Check if kernel size is odd
//     if (kernel_size % 2 == 0) {
//         std::cerr << "Kernel size must be odd for symmetric convolution." << std::endl;
//         return 1;
//     }

//     Var x("x"), k("k");
//     Func conv("conv");

//     // Define the 1D convolution
//     conv(x) = cast<T>(0);
//     for (int i = 0; i < kernel_size; ++i) {
//         // Cast both X(x + i - kernel_size / 2) and kernel(i) to Halide::Expr
//         conv(x) += cast<T>(X(x + i - kernel_size / 2)) * cast<T>(kernel(i));
//     }

//     // Scheduling
//     if (X_size > 16) {
//         Var xi("xi");
//         conv.vectorize(xi, 8).parallel(x);
//     } else {
//         if (X_size >= 8) {
//             conv.vectorize(x, 8);
//         }
//     }

//     // Realize the output
//     conv.realize(output);

//     return 0;
// }

// extern "C" {

// int conv1d_f64(CBuffer *output, CBuffer *X, CBuffer *kernel) {
//     if (!output || !X || !kernel) {
//         std::cerr << "Null pointer passed to conv1d." << std::endl;
//         return 1;
//     }

//     Halide::Buffer<double>* out_buf = reinterpret_cast<Halide::Buffer<double>*>(output);
//     Halide::Buffer<double>* X_buf = reinterpret_cast<Halide::Buffer<double>*>(X);
//     Halide::Buffer<double>* kernel_buf = reinterpret_cast<Halide::Buffer<double>*>(kernel);

//     return _conv1d(*out_buf, *X_buf, *kernel_buf);
// }

// int conv1d_f32(CBuffer *output, CBuffer *X, CBuffer *kernel) {
//     if (!output || !X || !kernel) {
//         std::cerr << "Null pointer passed to conv1d." << std::endl;
//         return 1;
//     }

//     Halide::Buffer<float>* out_buf = reinterpret_cast<Halide::Buffer<float>*>(output);
//     Halide::Buffer<float>* X_buf = reinterpret_cast<Halide::Buffer<float>*>(X);
//     Halide::Buffer<float>* kernel_buf = reinterpret_cast<Halide::Buffer<float>*>(kernel);

//     return _conv1d(*out_buf, *X_buf, *kernel_buf);
// }

// } // extern "C"
