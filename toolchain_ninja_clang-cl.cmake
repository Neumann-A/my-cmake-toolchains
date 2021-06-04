include_guard(GLOBAL)

message(STATUS "Loading clang-cl using ninja toolchain!")
if (DEFINED ENV{ProgramW6432})
    file(TO_CMAKE_PATH "$ENV{ProgramW6432}" PROG_ROOT)
else()
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" PROG_ROOT)
endif()

find_program(CLANG_CL clang-cl HINTS "${PROG_ROOT}/LLVM/bin")
if(NOT CLANG_CL AND NOT CMAKE_CXX_COMPILER MATCHES "clang-cl")
    message(FATAL_ERROR "Unable to find clang-cl with hint '${PROG_ROOT}/LLVM/bin'")
else()
    get_filename_component(LLVM_BIN_DIR "${CLANG_CL}" DIRECTORY CACHE)
    message(STATUS "Found clang-cl in ${LLVM_BIN_DIR}")
    list(APPEND CMAKE_PROGRAM_PATH "${LLVM_BIN_DIR}")
endif()

if(NOT DEFINED CMAKE_C_COMPILER)
    set(CMAKE_C_COMPILER "${LLVM_BIN_DIR}/clang-cl.exe")
endif()
if(NOT DEFINED CMAKE_CXX_COMPILER)
    set(CMAKE_CXX_COMPILER "${LLVM_BIN_DIR}/clang-cl.exe")
endif()
if(NOT DEFINED CMAKE_LINKER)
    set(CMAKE_LINKER "${LLVM_BIN_DIR}/lld-link.exe")
endif()
if(NOT DEFINED CMAKE_AR)
    set(CMAKE_AR "${LLVM_BIN_DIR}/llvm-lib.exe")
endif()
if(NOT DEFINED CMAKE_RANLIB)
    set(CMAKE_RANLIB)
endif()
if(NOT DEFINED CMAKE_RC_COMPILER)
    set(CMAKE_RC_COMPILER "${LLVM_BIN_DIR}/llvm-rc.exe")
endif()
if(NOT DEFINED CMAKE_NM)
    set(CMAKE_NM "${LLVM_BIN_DIR}/llvm-nm.exe")
endif()
set(CMAKE_MT "mt.exe")

include("${CMAKE_CURRENT_LIST_DIR}/toolchain_msvc_general.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/toolchain_vs_llvm.cmake")

