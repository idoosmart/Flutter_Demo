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

# 16 KB 页面对齐：NDK r28 起对 arm64-v8a / x86_64 已是默认行为，
# 此处显式保留，确保用 r27 及更低版本 NDK 构建时仍然合规。
target_link_options(protocol_ffi PRIVATE "-Wl,-z,max-page-size=16384")
target_link_options(protocol_ffi PRIVATE "-Wl,-z,common-page-size=16384")