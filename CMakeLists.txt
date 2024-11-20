cmake_minimum_required(VERSION 3.15)
project(jtjson)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

# Main JSON library
add_library(json STATIC
    json.cpp
)
target_link_libraries(json PRIVATE double-conversion)

# Tests
add_executable(json_test json_test.cpp)
target_link_libraries(json_test PRIVATE json)

add_executable(jsontestsuite_test jsontestsuite_test.cpp)
target_link_libraries(jsontestsuite_test PRIVATE json)

# Copy test data to build directory
add_custom_command(
    TARGET jsontestsuite_test POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/JSONTestSuite
        ${CMAKE_CURRENT_BINARY_DIR}/JSONTestSuite
)

enable_testing()
add_test(NAME json_test COMMAND json_test)
add_test(
    NAME jsontestsuite_test 
    COMMAND jsontestsuite_test
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
