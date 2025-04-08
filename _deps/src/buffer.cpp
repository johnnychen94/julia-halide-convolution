#include "Halide.h"
#include <iostream>
#include "buffer.h"

extern "C" {

CBuffer* create_buffer_from_bytes_1d_f64(unsigned char *data, int length) {
    try {
        auto* double_ptr = reinterpret_cast<double*>(data);
        auto* _buf = new Halide::Buffer<double, 1>(double_ptr, length);
        return reinterpret_cast<CBuffer*>(_buf);
    } catch (const std::exception &e) {
        std::cerr << "Exception creating Halide buffer: " << e.what() << std::endl;
        return nullptr;
    }
}

CBuffer* create_buffer_from_bytes_1d_f32(unsigned char *data, int length) {
    try {
        auto* float_ptr = reinterpret_cast<float*>(data);
        auto* _buf = new Halide::Buffer<float, 1>(float_ptr, length);
        return reinterpret_cast<CBuffer*>(_buf);
    } catch (const std::exception &e) {
        std::cerr << "Exception creating Halide buffer: " << e.what() << std::endl;
        return nullptr;
    }
}

CBuffer* create_buffer_from_bytes_2d_f64(unsigned char *data, int rows, int cols) {
    try {
        auto* double_ptr = reinterpret_cast<double*>(data);
        auto* _buf = new Halide::Buffer<double, 2>(double_ptr, cols, rows);
        return reinterpret_cast<CBuffer*>(_buf);
    } catch (const std::exception &e) {
        std::cerr << "Exception creating Halide buffer: " << e.what() << std::endl;
        return nullptr;
    }
}

CBuffer* create_buffer_from_bytes_2d_f32(unsigned char *data, int rows, int cols) {
    try {
        auto* float_ptr = reinterpret_cast<float*>(data);
        auto* _buf = new Halide::Buffer<float, 2>(float_ptr, cols, rows);
        return reinterpret_cast<CBuffer*>(_buf);
    } catch (const std::exception &e) {
        std::cerr << "Exception creating Halide buffer: " << e.what() << std::endl;
        return nullptr;
    }
}

void destroy_buffer(CBuffer *buffer) {
    if (buffer) {
        delete reinterpret_cast<Halide::Buffer<void>*>(buffer);
    }
}

double buffer_getindex_1d_f64(CBuffer *buffer, int index) {
    auto *buf = reinterpret_cast<Halide::Buffer<double, 1>*>(buffer);
    return (*buf)(index);
}

float buffer_getindex_1d_f32(CBuffer *buffer, int index) {
    auto *buf = reinterpret_cast<Halide::Buffer<float, 1>*>(buffer);
    return (*buf)(index);
}

double buffer_getindex_2d_f64(CBuffer *buffer, int i, int j) {
    auto *buf = reinterpret_cast<Halide::Buffer<double, 2>*>(buffer);
    return (*buf)(i, j);
}

float buffer_getindex_2d_f32(CBuffer *buffer, int i, int j) {
    auto *buf = reinterpret_cast<Halide::Buffer<float, 2>*>(buffer);
    return (*buf)(i, j);
}

void buffer_setindex_1d_f64(CBuffer *buffer, double value, int index) {
    auto *buf = reinterpret_cast<Halide::Buffer<double, 1>*>(buffer);
    (*buf)(index) = value;
}

void buffer_setindex_1d_f32(CBuffer *buffer, float value, int index) {
    auto *buf = reinterpret_cast<Halide::Buffer<float, 1>*>(buffer);
    (*buf)(index) = value;
}

void buffer_setindex_2d_f64(CBuffer *buffer, double value, int i, int j) {
    auto *buf = reinterpret_cast<Halide::Buffer<double, 2>*>(buffer);
    (*buf)(i, j) = value;
}

void buffer_setindex_2d_f32(CBuffer *buffer, float value, int i, int j) {
    auto *buf = reinterpret_cast<Halide::Buffer<float, 2>*>(buffer);
    (*buf)(i, j) = value;
}

} // extern "C"
