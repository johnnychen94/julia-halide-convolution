#include <iostream>

#include <HalideRuntime.h>
#include "Halide.h"

#include "common.h"
#include "libconv.h"

#include "aot_conv1d_i8.h"
#include "aot_conv1d_i16.h"
#include "aot_conv1d_i32.h"
#include "aot_conv1d_i64.h"
#include "aot_conv1d_u8.h"
#include "aot_conv1d_u16.h"
#include "aot_conv1d_u32.h"
#include "aot_conv1d_u64.h"
#include "aot_conv1d_f32.h"
#include "aot_conv1d_f64.h"

#define IMPLEMENT_CONV1D_FUNCTION(TYPE, SUFFIX)                                         \
    extern "C" int conv1d_##SUFFIX(CBuffer *input, CBuffer *kernel, CBuffer *output)    \
    {                                                                                   \
        if (!output || !input || !kernel)                                               \
        {                                                                               \
            std::cerr << "Null pointer passed to conv1d_" #SUFFIX "." << std::endl;     \
            return 1;                                                                   \
        }                                                                               \
        try                                                                             \
        {                                                                               \
            auto *in_buf = reinterpret_cast<Halide::Buffer<TYPE> *>(input);             \
            auto *kernel_buf = reinterpret_cast<Halide::Buffer<TYPE> *>(kernel);        \
            auto *out_buf = reinterpret_cast<Halide::Buffer<TYPE> *>(output);           \
            return aot_conv1d_##SUFFIX(                                                 \
                in_buf->raw_buffer(), kernel_buf->raw_buffer(), out_buf->raw_buffer()); \
        }                                                                               \
        catch (const std::exception &e)                                                 \
        {                                                                               \
            std::cerr << "Exception in conv1d_" #SUFFIX ": " << e.what() << std::endl;  \
            return 1;                                                                   \
        }                                                                               \
    }

// conv1d
IMPLEMENT_CONV1D_FUNCTION(int8_t, i8)
IMPLEMENT_CONV1D_FUNCTION(int16_t, i16)
IMPLEMENT_CONV1D_FUNCTION(int32_t, i32)
IMPLEMENT_CONV1D_FUNCTION(int64_t, i64)
IMPLEMENT_CONV1D_FUNCTION(uint8_t, u8)
IMPLEMENT_CONV1D_FUNCTION(uint16_t, u16)
IMPLEMENT_CONV1D_FUNCTION(uint32_t, u32)
IMPLEMENT_CONV1D_FUNCTION(uint64_t, u64)
IMPLEMENT_CONV1D_FUNCTION(float, f32)
IMPLEMENT_CONV1D_FUNCTION(double, f64)
