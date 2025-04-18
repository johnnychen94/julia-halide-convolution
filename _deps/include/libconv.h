#ifndef LIBCONV_AOT_H
#define LIBCONV_AOT_H

#include "buffer.h"
#include "common.h"

#ifdef __cplusplus
extern "C"
{
#endif

    LIBAPI int conv1d_u8(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_u16(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_u32(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_u64(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_i8(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_i16(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_i32(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_i64(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_f32(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_f64(CBuffer *input, CBuffer *kernel, CBuffer *output);

#ifdef __cplusplus
}
#endif

#endif // LIBCONV_AOT_H
