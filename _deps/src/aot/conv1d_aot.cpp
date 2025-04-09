#include "conv1d_f64_aot.h"
#include "conv1d_f32_aot.h"
#include <HalideRuntime.h>
#include <iostream>
#include "buffer.h"

extern "C"
{
    int conv1d_f64_aot_wrapper(CBuffer *output, CBuffer *X, CBuffer *kernel)
    {
        if (!output || !X || !kernel)
        {
            std::cerr << "Null pointer passed to conv1d_f64_aot_wrapper." << std::endl;
            return 1;
        }

        try
        {
            auto *out_buf = reinterpret_cast<halide_buffer_t *>(output);
            auto *X_buf = reinterpret_cast<halide_buffer_t *>(X);
            auto *kernel_buf = reinterpret_cast<halide_buffer_t *>(kernel);
            return conv1d_f64_aot(X_buf, kernel_buf, out_buf);
        }
        catch (const std::exception &e)
        {
            std::cerr << "Exception in conv1d_f64_aot_wrapper: " << e.what() << std::endl;
            return 1;
        }
    }

    int conv1d_f32_aot_wrapper(CBuffer *output, CBuffer *X, CBuffer *kernel)
    {
        if (!output || !X || !kernel)
        {
            std::cerr << "Null pointer passed to conv1d_f32_aot_wrapper." << std::endl;
            return 1;
        }

        try
        {
            auto *out_buf = reinterpret_cast<halide_buffer_t *>(output);
            auto *X_buf = reinterpret_cast<halide_buffer_t *>(X);
            auto *kernel_buf = reinterpret_cast<halide_buffer_t *>(kernel);
            return conv1d_f32_aot(X_buf, kernel_buf, out_buf);
        }
        catch (const std::exception &e)
        {
            std::cerr << "Exception in conv1d_f32_aot_wrapper: " << e.what() << std::endl;
            return 1;
        }
    }

} // extern "C"
