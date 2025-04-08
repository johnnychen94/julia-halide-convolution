#ifndef MAT_H
#define MAT_H

#include "common.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer to represent Halide::Buffer in C
// This is a C-compatible way to represent a Halide::Buffer object
// We can't use Halide::Buffer directly in C because it's a C++ class
// and C doesn't understand C++ classes.
struct CBuffer;

LIBAPI
CBuffer* create_halide_buffer_from_bytes_1d(unsigned char *data, int length);

LIBAPI
void destroy_halide_buffer(CBuffer *buffer);

#ifdef __cplusplus
}
#endif

#endif // MAT_H
