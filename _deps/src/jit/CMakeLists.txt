add_library(libconv_jit SHARED
    buffer.cpp
    conv1d.cpp
    gradient.cpp)

target_include_directories(libconv_jit PUBLIC
    ${PROJECT_SOURCE_DIR}/include)

target_link_libraries(libconv_jit PRIVATE
    Halide::Halide
    pthread
    dl)

# Set API visibility
set_target_properties(libconv_jit PROPERTIES C_VISIBILITY_PRESET hidden)
target_compile_definitions(libconv_jit PRIVATE LIBCONV_EXPORTS)
if(WIN32)
    include(GenerateExportHeader)
endif()

# copy the libhalide.{dll,so} to the build directory and set the rpath
# so that it can be found at runtime
set_target_properties(libconv_jit PROPERTIES
    C_VISIBILITY_PRESET hidden
    INSTALL_RPATH "\$ORIGIN"
    BUILD_WITH_INSTALL_RPATH ON)

# Configure installation
get_target_property(HALIDE_DLL_PATH Halide::Halide LOCATION)
if (NOT HALIDE_DLL_PATH)
    message(FATAL_ERROR "Halide DLL not found!")
endif()

if(WIN32)
    install(TARGETS libconv_jit DESTINATION bin)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION bin)
else()
    install(TARGETS libconv_jit DESTINATION lib)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION lib)
endif()
