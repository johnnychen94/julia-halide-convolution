#include "Halide.h"
#include <iostream>
#include "buffer.h"

using namespace Halide;

template <typename T>
int _gradient2d(Halide::Buffer<T> input) {
    Func gradient("gradient");
    Var x("x"), y("y");
    gradient(x, y) = input(x, y) + 0.5f;
    gradient.realize(input);
    return 0;
}

extern "C" {

int gradient2d_f64(CBuffer *output) {
    if (!output) {
        std::cerr << "Null pointer passed to gradient2d." << std::endl;
        return 1;
    }

    Halide::Buffer<double>* out_buf = reinterpret_cast<Halide::Buffer<double>*>(output);
    return _gradient2d(*out_buf);
}

int gradient2d_f32(CBuffer *output) {
    if (!output) {
        std::cerr << "Null pointer passed to gradient2d." << std::endl;
        return 1;
    }

    Halide::Buffer<float>* out_buf = reinterpret_cast<Halide::Buffer<float>*>(output);
    return _gradient2d(*out_buf);
}

} // extern "C"
