#include "conv1d_f64_aot.h"
#include "conv1d_f32_aot.h"
#include <HalideRuntime.h>
#include "Halide.h"
#include <iostream>
#include "buffer.h"

extern "C"
{
    int conv1d_f64_aot_wrapper(CBuffer *input, CBuffer *kernel, CBuffer *output)
    {
        if (!output || !input || !kernel)
        {
            std::cerr << "Null pointer passed to conv1d_f64_aot_wrapper." << std::endl;
            return 1;
        }

        try
        {
            Halide::Buffer<double> *in_buf = reinterpret_cast<Halide::Buffer<double> *>(input);
            Halide::Buffer<double> *kernel_buf = reinterpret_cast<Halide::Buffer<double> *>(kernel);
            Halide::Buffer<double> *out_buf = reinterpret_cast<Halide::Buffer<double> *>(output);

            return conv1d_f64_aot(in_buf->raw_buffer(), kernel_buf->raw_buffer(), out_buf->raw_buffer());
        }
        catch (const std::exception &e)
        {
            std::cerr << "Exception in conv1d_f64_aot_wrapper: " << e.what() << std::endl;
            return 1;
        }
    }

    int conv1d_f32_aot_wrapper(CBuffer *input, CBuffer *kernel, CBuffer *output)
    {
        if (!output || !input || !kernel)
        {
            std::cerr << "Null pointer passed to conv1d_f32_aot_wrapper." << std::endl;
            return 1;
        }

        try
        {
            Halide::Buffer<float> *in_buf = reinterpret_cast<Halide::Buffer<float> *>(input);
            Halide::Buffer<float> *kernel_buf = reinterpret_cast<Halide::Buffer<float> *>(kernel);
            Halide::Buffer<float> *out_buf = reinterpret_cast<Halide::Buffer<float> *>(output);

            return conv1d_f32_aot(in_buf->raw_buffer(), kernel_buf->raw_buffer(), out_buf->raw_buffer());
        }
        catch (const std::exception &e)
        {
            std::cerr << "Exception in conv1d_f32_aot_wrapper: " << e.what() << std::endl;
            return 1;
        }
    }

} // extern "C"
