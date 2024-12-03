#
# Configuration for IccMAXCmm in Build/Cmake/Tools/DemoIccMAXCmm/CMakeLists.txt
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Last Updated: 09-MAR-2025 2010 EDT by David Hoyt
#
# Changes:  Modified Build/Cmake/CMakeLists.txt and others
#           Added IccMAXCmm
#           Adjusted cross-platform build args
#
# TODO: Refactor Debug, Release, Asan 
#       Collapse 3-tier CMakeLists.txt, Housekeeping
#       Refactor Base Configs & logging to .mk's
#

message(STATUS "#################### Configuring IccMAXCmm ####################")

cmake_minimum_required(VERSION 3.16)
project(DemoIccMAXCmm)

# Ensure Windows-only build
if (NOT WIN32)
    message(FATAL_ERROR "This project is Windows-only.")
endif()

# Enable verbose logging
set(CMAKE_VERBOSE_MAKEFILE ON)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Define configurations
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)

# Define paths
set(SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../../Tools/Winnt/DemoIccMAXCmm")
set(TOP_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../..")
set(OUTPUT_DIR "${CMAKE_BINARY_DIR}/Tools/DemoIccMAXCmm/x64/Release")
file(MAKE_DIRECTORY ${OUTPUT_DIR})

set(SOURCES
    "${SOURCE_DIR}/stdafx.cpp"  # Must be first for PCH
    "${SOURCE_DIR}/DemoIccMAXCmm.cpp"
    "${SOURCE_DIR}/DemoIccMAXCmm.rc"
    "${SOURCE_DIR}/resource.h"
    "${SOURCE_DIR}/DemoIccMAXCmm.h"
    "${SOURCE_DIR}/stdafx.h"
)

# Define shared library
add_library(${PROJECT_NAME} SHARED ${SOURCES})

# Set consistent runtime library for MSVC
if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL$<$<CONFIG:Debug>:Debug>")
endif()

# Enable Precompiled Headers (PCH)
if(MSVC)
    set_source_files_properties("${SOURCE_DIR}/stdafx.cpp" PROPERTIES COMPILE_FLAGS "/Ycstdafx.h /Fp${OUTPUT_DIR}/DemoIccMAXCmm.pch")
    
    foreach(SRC ${SOURCES})
        if(NOT SRC STREQUAL "${SOURCE_DIR}/stdafx.cpp" AND SRC MATCHES "^.*\.cpp$")
            set_source_files_properties("${SRC}" PROPERTIES COMPILE_FLAGS "/Yustdafx.h /Fp${OUTPUT_DIR}/DemoIccMAXCmm.pch")
        endif()
    endforeach()
    
    # Exclude .rc files from precompiled headers
    set_source_files_properties("${SOURCE_DIR}/DemoIccMAXCmm.rc" PROPERTIES COMPILE_FLAGS "")
endif()

# Set character set
target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32 NDEBUG _WINDOWS _USRDLL DemoIccMAXCmm_EXPORTS _MBCS)

# Include directories
include_directories(${SOURCE_DIR} ${TOP_SOURCE_DIR}/IccProfLib)

# Hardcoded library path
target_link_libraries(${PROJECT_NAME} PRIVATE "C:/test/DemoIccMAX/Build/win/n/IccProfLib/Release/IccProfLib.lib")

# Linker options
set(LINK_LIBS
    Mscms.lib kernel32.lib user32.lib gdi32.lib winspool.lib
    comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib
    uuid.lib odbc32.lib odbccp32.lib
)

target_link_options(${PROJECT_NAME} PRIVATE
    "/OUT:${OUTPUT_DIR}/DemoIccMAXCmm.dll"
    "/PDB:${OUTPUT_DIR}/DemoIccMAXCmm.pdb"
    "/DYNAMICBASE:NO"
    "/DEF:${DEF_FILE}"
    "/NODEFAULTLIB:LIBCMT"
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${LINK_LIBS})

message(STATUS "#################### Exiting IccMAXCmm ####################")
