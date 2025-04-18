#ifndef COMMON_H
#define COMMON_H

#ifdef _WIN32
#define LIBAPI __declspec(dllexport)
#else
#define LIBAPI __attribute__((__visibility__("default")))
#endif

using float32_t = float;
using float64_t = double;

static_assert(sizeof(float32_t) == 4, "float32 should be 32 bit size");

#endif // COMMON_H
