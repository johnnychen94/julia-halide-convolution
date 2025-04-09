#ifndef COMMON_H
#define COMMON_H

#if defined(_WIN32) || defined(_WIN64)
#ifdef LIBCONV_EXPORTS
#define LIBAPI __declspec(dllexport)
#else
#define LIBAPI __declspec(dllimport)
#endif
#else
#define LIBAPI __attribute__((visibility("default")))
#endif

#endif // COMMON_H
