set(HALIDE_TYPES i8 i16 i32 i64 u8 u16 u32 u64 f32 f64)
set(AOT_COMPILE_FEATURES avx2 fma)
set(AOT_COMPILE_OPTIONS $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang,Intel>:-mavx2 -mfma>)

option(AOT_VERBOSE "Enable verbose prints in AOT conv1d generator" OFF)

add_halide_generator(conv1d_generator SOURCES conv1d.cpp)

target_include_directories(conv1d_generator PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

if(AOT_VERBOSE)
    target_compile_definitions(conv1d_generator PUBLIC AOT_VERBOSE=1)
else()
    target_compile_definitions(conv1d_generator PUBLIC AOT_VERBOSE=0)
endif()

# generate the AOT conv1d targets
add_library(aot_conv1d_interface INTERFACE)
foreach(T ${HALIDE_TYPES})
    add_halide_library(aot_conv1d_${T} FROM conv1d_generator
        GENERATOR aot_conv1d_${T}
        FEATURES ${AOT_COMPILE_FEATURES}
    )
    target_compile_options(aot_conv1d_${T} PRIVATE ${AOT_COMPILE_OPTIONS})
    target_link_libraries(aot_conv1d_interface INTERFACE aot_conv1d_${T})
endforeach()
