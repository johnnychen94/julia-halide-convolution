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

LIBAPI CBuffer* create_buffer_from_bytes_1d_f64(unsigned char *data, int length);

LIBAPI CBuffer* create_buffer_from_bytes_1d_f32(unsigned char *data, int length);

LIBAPI CBuffer* create_buffer_from_bytes_2d_f64(unsigned char *data, int rows, int cols);

LIBAPI CBuffer* create_buffer_from_bytes_2d_f32(unsigned char *data, int rows, int cols);

LIBAPI void destroy_buffer(CBuffer *buffer);

LIBAPI double buffer_getindex_1d_f64(CBuffer *buffer, int index);

LIBAPI float buffer_getindex_1d_f32(CBuffer *buffer, int index);

LIBAPI double buffer_getindex_2d_f64(CBuffer *buffer, int i, int j);

LIBAPI float buffer_getindex_2d_f32(CBuffer *buffer, int i, int j);

LIBAPI void buffer_setindex_1d_f64(CBuffer *buffer, double value, int index);

LIBAPI void buffer_setindex_1d_f32(CBuffer *buffer, float value, int index);

LIBAPI void buffer_setindex_2d_f64(CBuffer *buffer, double value, int i, int j);

LIBAPI void buffer_setindex_2d_f32(CBuffer *buffer, float value, int i, int j);

#ifdef __cplusplus
}
#endif

#endif // MAT_H
