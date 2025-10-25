cmake_minimum_required(VERSION 3.15)
project(jtjson)

option(JSON_CPP_BUILD_TESTS "Enable building tests" ON)
option(DOUBLE_CONVERSION_VENDORED "Use vendored double-conversion library" ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (DOUBLE_CONVERSION_VENDORED)
    # Add double-conversion library
    add_library(double-conversion STATIC
        double-conversion/bignum.cc
        double-conversion/bignum-dtoa.cc
        double-conversion/cached-powers.cc
        double-conversion/double-to-string.cc
        double-conversion/fast-dtoa.cc
        double-conversion/fixed-dtoa.cc
        double-conversion/string-to-double.cc
        double-conversion/strtod.cc
    )
    target_include_directories(double-conversion PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
else()
    find_package(double-conversion REQUIRED)
endif()

# Main JSON library
# BUILD_SHARED_LIBS is a standard CMake variable that
# controls whether libraries are built as shared or static
add_library(json
    json.cpp
)
target_link_libraries(json PRIVATE double-conversion)
set_target_properties(json PROPERTIES PUBLIC_HEADER "json.h")

# Tests
if (JSON_CPP_BUILD_TESTS)
    add_executable(json_test json_test.cpp)
    target_link_libraries(json_test PRIVATE json)

    add_executable(jsontestsuite_test jsontestsuite_test.cpp)
    target_link_libraries(jsontestsuite_test PRIVATE json)

    # Copy test data to build directory
    add_custom_command(
        TARGET jsontestsuite_test POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${CMAKE_CURRENT_SOURCE_DIR}/JSONTestSuite
            ${CMAKE_CURRENT_BINARY_DIR}/JSONTestSuite
    )

enable_testing()
    enable_testing()
    add_test(NAME json_test COMMAND json_test)
    add_test(
        NAME jsontestsuite_test
        COMMAND jsontestsuite_test
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
endif()

include(GNUInstallDirs)
install(TARGETS json
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
