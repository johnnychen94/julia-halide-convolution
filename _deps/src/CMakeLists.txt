add_subdirectory(generators)

add_library(libconv SHARED
    buffer.cpp
    conv1d.cpp
    libconv.cpp
)

target_include_directories(libconv PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_compile_options(libconv PRIVATE
    $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang,Intel>:-mavx2 -mfma>
)

target_link_libraries(libconv
    PRIVATE
    Halide::Halide
    aot_conv1d_interface
)

# Set API visibility
if(WIN32)
    include(GenerateExportHeader)
endif()
set_target_properties(libconv PROPERTIES C_VISIBILITY_PRESET hidden)

# copy the libhalide.{dll,so} to the build directory and set the rpath
# so that it can be found at runtime
set_target_properties(libconv PROPERTIES
    INSTALL_RPATH "\$ORIGIN"
    BUILD_WITH_INSTALL_RPATH ON)

# Configure installation
get_target_property(HALIDE_DLL_PATH Halide::Halide LOCATION)
if (NOT HALIDE_DLL_PATH)
    message(FATAL_ERROR "Halide DLL not found!")
endif()

if(WIN32)
    install(TARGETS libconv DESTINATION bin)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION bin)
else()
    install(TARGETS libconv DESTINATION lib)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION lib)
endif()
