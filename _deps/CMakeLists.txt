cmake_minimum_required(VERSION 3.28)
project(libconv)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_SHARED_LIBRARY_PREFIX "")


find_package(Halide REQUIRED)
if (NOT Halide_FOUND)
    message(FATAL_ERROR "Halide not found!")
endif()

add_library(libconv SHARED src/conv1d.cpp src/buffer.cpp)
target_include_directories(libconv PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)
target_link_libraries(libconv PRIVATE Halide::Halide)
target_compile_definitions(libconv PRIVATE LIBCONV_EXPORTS)

if(WIN32)
    include(GenerateExportHeader)
endif()
set_target_properties(libconv PROPERTIES C_VISIBILITY_PRESET hidden)

if(WIN32)
    # Windows *.dll should be placed in bin directory
    # https://docs.binarybuilder.org/stable/build_tips/#CMake-builds
    install(TARGETS libconv DESTINATION bin)
else()
    install(TARGETS libconv DESTINATION lib)
endif()

install(TARGETS libconv
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include
        FILES_MATCHING PATTERN "*.h")
