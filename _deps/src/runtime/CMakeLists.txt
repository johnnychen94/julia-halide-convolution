add_library(libconv_runtime SHARED
    buffer.cpp)

target_link_libraries(libconv_runtime PRIVATE
    Halide::Halide
    pthread
    dl)

target_include_directories(libconv_runtime PUBLIC
    ${PROJECT_SOURCE_DIR}/include)

# Set API visibility
set_target_properties(libconv_runtime PROPERTIES C_VISIBILITY_PRESET hidden)
target_compile_definitions(libconv_runtime PRIVATE LIBCONV_EXPORTS)

# copy the libhalide.{dll,so} to the build directory and set the rpath
# so that it can be found at runtime
set_target_properties(libconv_runtime PROPERTIES
    C_VISIBILITY_PRESET hidden
    INSTALL_RPATH "\$ORIGIN"
    BUILD_WITH_INSTALL_RPATH ON)

# Configure installation
get_target_property(HALIDE_DLL_PATH Halide::Halide LOCATION)
if (NOT HALIDE_DLL_PATH)
    message(FATAL_ERROR "Halide DLL not found!")
endif()

if(WIN32)
    install(TARGETS libconv_runtime DESTINATION bin)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION bin)
else()
    install(TARGETS libconv_runtime DESTINATION lib)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION lib)
endif()
