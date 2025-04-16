#ifndef LIBCONV_AOT_H
#define LIBCONV_AOT_H

#include "buffer.h"
#include "common.h"

#ifdef __cplusplus
extern "C"
{
#endif

    LIBAPI int conv1d_f64_aot_wrapper(CBuffer *input, CBuffer *kernel, CBuffer *output);
    LIBAPI int conv1d_f32_aot_wrapper(CBuffer *input, CBuffer *kernel, CBuffer *output);

#ifdef __cplusplus
}
#endif

#endif // LIBCONV_AOT_H
