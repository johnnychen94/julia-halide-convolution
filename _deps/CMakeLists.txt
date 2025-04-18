cmake_minimum_required(VERSION 3.19)
project(libconv)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_SHARED_LIBRARY_PREFIX "")

find_package(Halide REQUIRED)
if(NOT Halide_FOUND)
    message(FATAL_ERROR "Halide not found!")
endif()

add_subdirectory(src)

install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include
    FILES_MATCHING PATTERN "*.h")
