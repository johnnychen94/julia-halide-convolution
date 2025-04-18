#include "buffer.h"
#include "common.h"
#include <iostream>
#include <Halide.h>

template <typename T, int N, typename... Dims>
CBuffer *create_buffer_from_bytes(unsigned char *data, Dims... dims)
{
    if (!data)
    {
        std::cerr << "Null pointer passed to create_buffer_from_bytes" << std::endl;
        return nullptr;
    }

    try
    {
        auto *data_ptr = reinterpret_cast<T *>(data);
        auto *buf = new Halide::Buffer<T, N>(data_ptr, dims...);
        return reinterpret_cast<CBuffer *>(buf);
    }
    catch (const std::exception &e)
    {
        std::cerr << "Exception creating Halide buffer: " << e.what() << std::endl;
        return nullptr;
    }
}

template <typename T, int N>
T buffer_getindex(CBuffer *buffer, int i, int j = 0)
{
    auto *buf = reinterpret_cast<Halide::Buffer<T, N> *>(buffer);
    if constexpr (N == 1)
    {
        return (*buf)(i);
    }
    else
    {
        return (*buf)(i, j);
    }
}

template <typename T, int N>
void buffer_setindex(CBuffer *buffer, T value, int i, int j = 0)
{
    auto *buf = reinterpret_cast<Halide::Buffer<T, N> *>(buffer);
    if constexpr (N == 1)
    {
        (*buf)(i) = value;
    }
    else
    {
        (*buf)(i, j) = value;
    }
}

// Macros for generating C wrappers
#define DECLARE_BUFFER_CREATE_FUNCTIONS(TYPE, SUFFIX)                                                        \
    extern "C" LIBAPI CBuffer *create_buffer_from_bytes_1d_##SUFFIX(unsigned char *data, int length)         \
    {                                                                                                        \
        return create_buffer_from_bytes<TYPE, 1>(data, length);                                              \
    }                                                                                                        \
    extern "C" LIBAPI CBuffer *create_buffer_from_bytes_2d_##SUFFIX(unsigned char *data, int rows, int cols) \
    {                                                                                                        \
        return create_buffer_from_bytes<TYPE, 2>(data, rows, cols);                                          \
    }

#define DECLARE_BUFFER_GET_FUNCTIONS(TYPE, SUFFIX)                                    \
    extern "C" LIBAPI TYPE buffer_getindex_1d_##SUFFIX(CBuffer *buffer, int index)    \
    {                                                                                 \
        return buffer_getindex<TYPE, 1>(buffer, index);                               \
    }                                                                                 \
    extern "C" LIBAPI TYPE buffer_getindex_2d_##SUFFIX(CBuffer *buffer, int i, int j) \
    {                                                                                 \
        return buffer_getindex<TYPE, 2>(buffer, i, j);                                \
    }

#define DECLARE_BUFFER_SET_FUNCTIONS(TYPE, SUFFIX)                                                \
    extern "C" LIBAPI void buffer_setindex_1d_##SUFFIX(CBuffer *buffer, TYPE value, int index)    \
    {                                                                                             \
        buffer_setindex<TYPE, 1>(buffer, value, index);                                           \
    }                                                                                             \
    extern "C" LIBAPI void buffer_setindex_2d_##SUFFIX(CBuffer *buffer, TYPE value, int i, int j) \
    {                                                                                             \
        buffer_setindex<TYPE, 2>(buffer, value, i, j);                                            \
    }

LIBAPI void destroy_buffer(CBuffer *buffer)
{
    if (buffer)
    {
        delete reinterpret_cast<Halide::Buffer<void> *>(buffer);
    }
}

// create_buffer_from_bytes
DECLARE_BUFFER_CREATE_FUNCTIONS(uint8_t, u8)
DECLARE_BUFFER_CREATE_FUNCTIONS(uint16_t, u16)
DECLARE_BUFFER_CREATE_FUNCTIONS(uint32_t, u32)
DECLARE_BUFFER_CREATE_FUNCTIONS(uint64_t, u64)
DECLARE_BUFFER_CREATE_FUNCTIONS(int8_t, i8)
DECLARE_BUFFER_CREATE_FUNCTIONS(int16_t, i16)
DECLARE_BUFFER_CREATE_FUNCTIONS(int32_t, i32)
DECLARE_BUFFER_CREATE_FUNCTIONS(int64_t, i64)
DECLARE_BUFFER_CREATE_FUNCTIONS(float32_t, f32)
DECLARE_BUFFER_CREATE_FUNCTIONS(float64_t, f64)

// buffer_getindex
DECLARE_BUFFER_GET_FUNCTIONS(uint8_t, u8)
DECLARE_BUFFER_GET_FUNCTIONS(uint16_t, u16)
DECLARE_BUFFER_GET_FUNCTIONS(uint32_t, u32)
DECLARE_BUFFER_GET_FUNCTIONS(uint64_t, u64)
DECLARE_BUFFER_GET_FUNCTIONS(int8_t, i8)
DECLARE_BUFFER_GET_FUNCTIONS(int16_t, i16)
DECLARE_BUFFER_GET_FUNCTIONS(int32_t, i32)
DECLARE_BUFFER_GET_FUNCTIONS(int64_t, i64)
DECLARE_BUFFER_GET_FUNCTIONS(float32_t, f32)
DECLARE_BUFFER_GET_FUNCTIONS(float64_t, f64)

// buffer_setindex
DECLARE_BUFFER_SET_FUNCTIONS(uint8_t, u8)
DECLARE_BUFFER_SET_FUNCTIONS(uint16_t, u16)
DECLARE_BUFFER_SET_FUNCTIONS(uint32_t, u32)
DECLARE_BUFFER_SET_FUNCTIONS(uint64_t, u64)
DECLARE_BUFFER_SET_FUNCTIONS(int8_t, i8)
DECLARE_BUFFER_SET_FUNCTIONS(int16_t, i16)
DECLARE_BUFFER_SET_FUNCTIONS(int32_t, i32)
DECLARE_BUFFER_SET_FUNCTIONS(int64_t, i64)
DECLARE_BUFFER_SET_FUNCTIONS(float32_t, f32)
DECLARE_BUFFER_SET_FUNCTIONS(float64_t, f64)
