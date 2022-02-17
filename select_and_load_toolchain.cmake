# This file is for selection of a default toolchain for building

if(VCPKG_FOUND OR CMAKE_TOOLCHAIN_FILE MATCHES "vcpkg.cmake")
    set(TOOLCHAIN_VAR VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
else()
    set(TOOLCHAIN_VAR CMAKE_TOOLCHAIN_FILE)
endif()
include(CMakePrintHelpers)

message(STATUS "Selecting default toolchain:")

cmake_print_variables(CMAKE_SYSTEM_NAME CMAKE_C_COMPILER CMAKE_C_COMPILER_ID CMAKE_GENERATOR CMAKE_GENERATOR_TOOLSET)

if(CMAKE_GENERATOR STREQUAL "Ninja" AND NOT DEFINED ${TOOLCHAIN_VAR})
    if(CMAKE_SYSTEM_NAME MATCHES "Windows" OR WIN32 AND CMAKE_CXX_COMPILER MATCHES "clang-cl")
        message(STATUS "Selecting ninja clang-cl toolchain")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_ninja_clang-cl.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    elseif(UNIX AND NOT (CYGWIN OR APPLE) AND 
          ( (CMAKE_C_COMPILER_ID STREQUAL "Clang" OR CMAKE_C_COMPILER MATCHES "clang(\\\.exe)?$") 
          OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER MATCHES "clang++")))
        message(STATUS "Selecting ninja clang++ toolchain")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_ninja_clang++.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    elseif(UNIX AND NOT (CYGWIN OR APPLE) AND 
          ( (CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER MATCHES "gcc") 
          OR (CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER MATCHES "gcc") ) )
        message(STATUS "Selecting gcc toolchain")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_gcc.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    else()
        message(STATUS "No default toolchain selected!")
    endif()
elseif(CMAKE_GENERATOR MATCHES "Visual Studio" AND NOT DEFINED ${TOOLCHAIN_VAR})
    message(STATUS "Using VS Generator with platformtoolset: ${CMAKE_GENERATOR_TOOLSET}")
    if(CMAKE_GENERATOR_TOOLSET MATCHES "[Ll][Ll][Vv][Mm]")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_vs_llvm.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    elseif(CMAKE_GENERATOR_TOOLSET MATCHES "Intel")
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_vs_intel.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    else()
        set(${TOOLCHAIN_VAR} "${CMAKE_CURRENT_LIST_DIR}/toolchain_msvc_general.cmake" CACHE PATH "Used toolchain file beside VCPKG toolchain")
    endif()
else()
    message(STATUS "Using external toolchain!")
endif()

if(NOT DEFINED CACHE{${TOOLCHAIN_VAR}})
    set(${TOOLCHAIN_VAR} "${${TOOLCHAIN_VAR}}" CACHE PATH "Toolchain to use" FORCE)
else()
    set(${TOOLCHAIN_VAR} $CACHE{${TOOLCHAIN_VAR}})
endif()

message(STATUS "Using toolchain:")
cmake_print_variables(${TOOLCHAIN_VAR})