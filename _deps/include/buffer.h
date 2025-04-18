#ifndef BUFFER_H
#define BUFFER_H

#include <cstdint>

#include "Halide.h"

#include "common.h"

typedef struct CBuffer CBuffer;

#ifdef __cplusplus
extern "C"
{
#endif

    LIBAPI CBuffer *create_buffer_from_bytes_1d_u8(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_u16(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_u32(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_u64(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_i8(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_i16(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_i32(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_i64(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_f32(unsigned char *data, int length);
    LIBAPI CBuffer *create_buffer_from_bytes_1d_f64(unsigned char *data, int length);

    LIBAPI CBuffer *create_buffer_from_bytes_2d_u8(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_u16(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_u32(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_u64(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_i8(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_i16(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_i32(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_i64(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_f32(unsigned char *data, int rows, int cols);
    LIBAPI CBuffer *create_buffer_from_bytes_2d_f64(unsigned char *data, int rows, int cols);

    LIBAPI uint8_t buffer_getindex_1d_u8(CBuffer *buffer, int index);
    LIBAPI uint16_t buffer_getindex_1d_u16(CBuffer *buffer, int index);
    LIBAPI uint32_t buffer_getindex_1d_u32(CBuffer *buffer, int index);
    LIBAPI uint64_t buffer_getindex_1d_u64(CBuffer *buffer, int index);
    LIBAPI int8_t buffer_getindex_1d_i8(CBuffer *buffer, int index);
    LIBAPI int16_t buffer_getindex_1d_i16(CBuffer *buffer, int index);
    LIBAPI int32_t buffer_getindex_1d_i32(CBuffer *buffer, int index);
    LIBAPI int64_t buffer_getindex_1d_i64(CBuffer *buffer, int index);
    LIBAPI float32_t buffer_getindex_1d_f32(CBuffer *buffer, int index);
    LIBAPI float64_t buffer_getindex_1d_f64(CBuffer *buffer, int index);

    LIBAPI uint8_t buffer_getindex_2d_u8(CBuffer *buffer, int i, int j);
    LIBAPI uint16_t buffer_getindex_2d_u16(CBuffer *buffer, int i, int j);
    LIBAPI uint32_t buffer_getindex_2d_u32(CBuffer *buffer, int i, int j);
    LIBAPI uint64_t buffer_getindex_2d_u64(CBuffer *buffer, int i, int j);
    LIBAPI int8_t buffer_getindex_2d_i8(CBuffer *buffer, int i, int j);
    LIBAPI int16_t buffer_getindex_2d_i16(CBuffer *buffer, int i, int j);
    LIBAPI int32_t buffer_getindex_2d_i32(CBuffer *buffer, int i, int j);
    LIBAPI int64_t buffer_getindex_2d_i64(CBuffer *buffer, int i, int j);
    LIBAPI float32_t buffer_getindex_2d_f32(CBuffer *buffer, int i, int j);
    LIBAPI float64_t buffer_getindex_2d_f64(CBuffer *buffer, int i, int j);

    LIBAPI void buffer_setindex_1d_u8(CBuffer *buffer, uint8_t value, int index);
    LIBAPI void buffer_setindex_1d_u16(CBuffer *buffer, uint16_t value, int index);
    LIBAPI void buffer_setindex_1d_u32(CBuffer *buffer, uint32_t value, int index);
    LIBAPI void buffer_setindex_1d_u64(CBuffer *buffer, uint64_t value, int index);
    LIBAPI void buffer_setindex_1d_i8(CBuffer *buffer, int8_t value, int index);
    LIBAPI void buffer_setindex_1d_i16(CBuffer *buffer, int16_t value, int index);
    LIBAPI void buffer_setindex_1d_i32(CBuffer *buffer, int32_t value, int index);
    LIBAPI void buffer_setindex_1d_i64(CBuffer *buffer, int64_t value, int index);
    LIBAPI void buffer_setindex_1d_f32(CBuffer *buffer, float32_t value, int index);
    LIBAPI void buffer_setindex_1d_f64(CBuffer *buffer, float64_t value, int index);

    LIBAPI void buffer_setindex_2d_u8(CBuffer *buffer, uint8_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_u16(CBuffer *buffer, uint16_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_u32(CBuffer *buffer, uint32_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_u64(CBuffer *buffer, uint64_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_i8(CBuffer *buffer, int8_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_i16(CBuffer *buffer, int16_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_i32(CBuffer *buffer, int32_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_i64(CBuffer *buffer, int64_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_f32(CBuffer *buffer, float32_t value, int i, int j);
    LIBAPI void buffer_setindex_2d_f64(CBuffer *buffer, float64_t value, int i, int j);

    LIBAPI void destroy_buffer(CBuffer *buffer);

#ifdef __cplusplus
}
#endif

#endif // BUFFER_H
