#include "Halide.h"
#include "HalideRuntime.h"
#include <iostream>
#include "buffer.h"

extern "C" {

CBuffer* create_halide_buffer_from_bytes_1d(unsigned char *data, int length) {
    try {
        auto* double_ptr = reinterpret_cast<double*>(data);
        auto* _buf = new Halide::Buffer<double, 1>(double_ptr, length);
        return reinterpret_cast<CBuffer*>(_buf);
    } catch (const std::exception &e) {
        std::cerr << "Exception creating Halide buffer: " << e.what() << std::endl;
        return nullptr;
    }
}

void destroy_halide_buffer(CBuffer *buffer) {
    if (!buffer)
        return;
    auto *buf = reinterpret_cast<Halide::Buffer<double>*>(buffer);
    delete buf;
}

} // extern "C"
