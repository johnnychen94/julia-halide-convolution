# Generators
add_halide_generator(conv1d_generator SOURCES conv1d_generator.cpp)
add_halide_library(conv1d_f64_aot FROM conv1d_generator
                   GENERATOR conv1d_f64_aot)
add_halide_library(conv1d_f32_aot FROM conv1d_generator
                   GENERATOR conv1d_f32_aot)

add_library(libconv_aot SHARED
    conv1d_aot.cpp)

target_include_directories(libconv_aot PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(libconv_aot
    PRIVATE
    libconv_runtime
    conv1d_f64_aot
    conv1d_f32_aot
)

set_target_properties(libconv_aot PROPERTIES C_VISIBILITY_PRESET hidden)
target_compile_definitions(libconv_aot PRIVATE LIBCONV_EXPORTS)
if(WIN32)
    include(GenerateExportHeader)
endif()

# installation
if(WIN32)
    install(TARGETS libconv_aot DESTINATION bin)
else()
    install(TARGETS libconv_aot DESTINATION lib)
endif()
