#include "Halide.h"
#include <iostream>
#include "buffer.h"

using namespace Halide;

// Internal function that performs 1D convolution on 1D Buffers of type double.
// Returns 0 on success or a nonzero error code on failure.
int _conv1d(Halide::Buffer<double> output,
            Halide::Buffer<double> input,
            Halide::Buffer<double> kernel) {

    // Check that all buffers are one-dimensional.
    if (input.dimensions() != 1 || kernel.dimensions() != 1 || output.dimensions() != 1) {
        std::cerr << "Error: All buffers must be 1D." << std::endl;
        return 2;
    }

    // Check size compatibility:
    // For a valid convolution, output.width() must equal input.width() - kernel.width() + 1.
    if (output.width() != input.width() - kernel.width() + 1) {
        std::cerr << "Error: Output size (" << output.width()
                  << ") does not match input width (" << input.width()
                  << ") - kernel width (" << kernel.width() << ") + 1." << std::endl;
        return 3;
    }

    Var x;
    Func conv("conv");
    // Define a reduction domain over the kernel.
    RDom r(0, kernel.width());
    conv(x) = sum(input(x + r) * kernel(r));

    // Realize the function into the output buffer.
    conv.realize(output);

    return 0;
}

extern "C" {

int conv1d_f64(CBuffer *output, CBuffer *input, CBuffer *kernel) {
    // Basic null pointer check.
    if (!output || !input || !kernel) {
        std::cerr << "Null pointer passed to conv1d." << std::endl;
        return 1;
    }

    Halide::Buffer<double>* out_buf = reinterpret_cast<Halide::Buffer<double>*>(output);
    Halide::Buffer<double>* in_buf = reinterpret_cast<Halide::Buffer<double>*>(input);
    Halide::Buffer<double>* kern_buf = reinterpret_cast<Halide::Buffer<double>*>(kernel);

    return _conv1d(*out_buf, *in_buf, *kern_buf);
}

} // extern "C"
