cmake_minimum_required(VERSION 3.19)
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

add_library(libconv SHARED src/conv1d.cpp src/buffer.cpp src/gradient.cpp)
target_include_directories(libconv PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)
target_link_libraries(libconv PRIVATE Halide::Halide pthread dl)
target_compile_definitions(libconv PRIVATE LIBCONV_EXPORTS)

if(WIN32)
    include(GenerateExportHeader)
endif()
set_target_properties(libconv PROPERTIES C_VISIBILITY_PRESET hidden)

get_target_property(HALIDE_DLL_PATH Halide::Halide LOCATION)
if (NOT HALIDE_DLL_PATH)
    message(FATAL_ERROR "Halide DLL not found!")
endif()

if(WIN32)
    # Windows *.dll needs to be placed in bin directory
    # https://docs.binarybuilder.org/stable/build_tips/#CMake-builds
    install(TARGETS libconv DESTINATION bin)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION bin)
else()
    install(TARGETS libconv DESTINATION lib)
    install(FILES "${HALIDE_DLL_PATH}" DESTINATION lib)
endif()
set_target_properties(libconv PROPERTIES
    INSTALL_RPATH "\$ORIGIN"
    BUILD_WITH_INSTALL_RPATH ON
)

install(TARGETS libconv
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include
        FILES_MATCHING PATTERN "*.h")
