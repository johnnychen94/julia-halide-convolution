cmake_minimum_required(VERSION 3.19)
project(libconv)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_SHARED_LIBRARY_PREFIX "")

# Find Halide package
find_package(Halide REQUIRED)
if (NOT Halide_FOUND)
    message(FATAL_ERROR "Halide not found!")
endif()

# Generate directory for AOT compiled code
set(AOT_GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
file(MAKE_DIRECTORY "${AOT_GENERATED_DIR}")

# Add subdirectories in the correct order
# runtime first since others depend on it
add_subdirectory(src/runtime)
add_subdirectory(src/jit)
add_subdirectory(src/aot)

install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include
    FILES_MATCHING PATTERN "*.h")
