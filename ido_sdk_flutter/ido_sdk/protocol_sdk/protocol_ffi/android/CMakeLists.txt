cmake_minimum_required(VERSION 3.4.1)

#include_directories(${CMAKE_SOURCE_DIR}/src/main/cpp)

add_library(protocol_c SHARED IMPORTED)
set_target_properties(protocol_c PROPERTIES IMPORTED_LOCATION
        ${CMAKE_SOURCE_DIR}/src/main/libs/${ANDROID_ABI}/libprotocol_c.so)

add_library( # Sets the name of the library.
        protocol_ffi             # Sets the library as a shared library.
        SHARED             # Provides a relative path to your source file(s).
        src/main/cpp/native-lib.cpp)

find_library( # Sets the name of the path variable.
        log-lib              # Specifies the name of the NDK library that
        # you want CMake to locate.
        log )
#
target_link_libraries( # Specifies the target library.
        protocol_ffi protocol_c                       # Links the target library to the log library
        android
        # included in the NDK.
        ${log-lib} )
