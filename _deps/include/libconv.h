#ifndef LIBCONV_H
#define LIBCONV_H

#include "buffer.h"
#include "common.h"


#ifdef __cplusplus
extern "C" {
#endif

LIBAPI
int conv1d_f64(CBuffer *output, CBuffer *input, CBuffer *kernel);

#ifdef __cplusplus
}
#endif

#endif // LIBCONV_H
