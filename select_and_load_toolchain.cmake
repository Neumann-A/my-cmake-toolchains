# This file is for selection of a default toolchain for building

if(VCPKG_FOUND OR CMAKE_TOOLCHAIN_FILE MATCHES "vcpkg.cmake")
    set(TOOLCHAIN_VAR VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
else()
    set(TOOLCHAIN_VAR CMAKE_TOOLCHAIN_FILE)
endif()
include(CMakePrintHelpers)
cmake_print_variables(CMAKE_CURRENT_SOURCE_DIR CMAKE_GENERATOR CMAKE_GENERATOR_TOOLSET VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
if(CMAKE_GENERATOR STREQUAL "Ninja" AND NOT DEFINED VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
    if(CMAKE_SYSTEM_NAME MATCHES "Windows")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_ninja_clang-cl.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    elseif(UNIX AND NOT (CYGWIN OR APPLE))
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_ninja_clang++.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    endif()
elseif(CMAKE_GENERATOR MATCHES "Visual Studio" AND NOT DEFINED VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
    message(STATUS "Using VS Generator with platformtoolset: ${CMAKE_GENERATOR_TOOLSET}")
    if(CMAKE_GENERATOR_TOOLSET MATCHES "[Ll][Ll][Vv][Mm]")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_vs_llvm.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    elseif(CMAKE_GENERATOR_TOOLSET MATCHES "Intel")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_vs_intel.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    else()
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_msvc_general.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    endif()
endif()