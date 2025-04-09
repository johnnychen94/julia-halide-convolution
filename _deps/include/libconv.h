#ifndef LIBCONV_H
#define LIBCONV_H

#include "buffer.h"
#include "common.h"

#ifdef __cplusplus
extern "C"
{
#endif

    LIBAPI int conv1d_f64(CBuffer *output, CBuffer *input, CBuffer *kernel);
    LIBAPI int conv1d_f32(CBuffer *output, CBuffer *input, CBuffer *kernel);

    LIBAPI int gradient2d_f64(CBuffer *output);
    LIBAPI int gradient2d_f32(CBuffer *output);

#ifdef __cplusplus
}
#endif

#endif // LIBCONV_H
