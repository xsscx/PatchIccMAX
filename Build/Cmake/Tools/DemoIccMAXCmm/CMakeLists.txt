################################################################################
#
# Configuration for IccMAXCmm in Build/Cmake/Tools/DemoIccMAXCmm/CMakeLists.txt
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Last Updated: 14-MAR-2025 1007 EDT by David Hoyt
#
# Changes:  Modified Build/Cmake/CMakeLists.txt and others
# TODO :    Adjusted CMM build, wrapped build type in conditional
#           Debug to MinSizeRel and x64-Debug - IN PROCESS
#           Library path.part hardcoded
#           Refactor for x64-MinSizeRel, x64-Debug, Unix/Win/macOS wrap
#           HARDCODED - Release or Debug, needs rel-debug wrapper
#           Refactor Debug, Release, Asan 
#           Collapse 3-tier CMakeLists.txt, Housekeeping
#           Refactor Base Configs & logging to .mk's
#
#
#
#
################################################################################

cmake_minimum_required(VERSION 3.16)
project(DemoIccMAXCmm)

# Allow configuration on all platforms but only build on Windows
if (NOT WIN32)
    message(WARNING "This project is designed for Windows only. Configuration will succeed, but it will not be built on this platform.")
    return()
endif()

message(STATUS "Configuring IccMAXCmm for Windows...")

# Compiler Settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_VERBOSE_MAKEFILE ON)

# Set Windows-specific source paths
set(OS_SPECIFIC_SOURCES "${CMAKE_CURRENT_LIST_DIR}/../../../../Tools/Winnt/DemoIccMAXCmm")

# Output Directory based on Configuration
set(OUTPUT_DIR "${CMAKE_BINARY_DIR}/Tools/DemoIccMAXCmm/x64/${CMAKE_BUILD_TYPE}")
file(MAKE_DIRECTORY ${OUTPUT_DIR})

# Source Files
set(SOURCES
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.cpp"
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.rc"
    "${OS_SPECIFIC_SOURCES}/resource.h"
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.h"
    "${OS_SPECIFIC_SOURCES}/stdafx.cpp"
    "${OS_SPECIFIC_SOURCES}/stdafx.h"
)

# Define Shared Library
add_library(${PROJECT_NAME} SHARED ${SOURCES})

# MSVC-Specific Settings
if (MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL$<$<CONFIG:Debug>:Debug>")
    set_source_files_properties("${OS_SPECIFIC_SOURCES}/stdafx.cpp" PROPERTIES COMPILE_FLAGS "/Ycstdafx.h /Fp${OUTPUT_DIR}/DemoIccMAXCmm.pch")
    foreach(SRC ${SOURCES})
        if(NOT SRC STREQUAL "${OS_SPECIFIC_SOURCES}/stdafx.cpp" AND SRC MATCHES "^.*\\.cpp$")
            set_source_files_properties("${SRC}" PROPERTIES COMPILE_FLAGS "/Yustdafx.h /Fp${OUTPUT_DIR}/DemoIccMAXCmm.pch")
        endif()
    endforeach()
    set_source_files_properties("${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.rc" PROPERTIES COMPILE_FLAGS "")
endif()

# Compiler Definitions
if (WIN32)
    target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32 _WINDOWS _USRDLL DemoIccMAXCmm_EXPORTS _MBCS)
endif()

# Include Directories
include_directories(${OS_SPECIFIC_SOURCES} ${TOP_SOURCE_DIR}/IccProfLib)

# Library Linking
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_link_libraries(${PROJECT_NAME} PRIVATE "F:/cross-platform/iccmax/Build/Cmake/IccProfLib/Debug/IccProfLib2-static.lib")
else()
    target_link_libraries(${PROJECT_NAME} PRIVATE "F:/cross-platform/iccmax/Build/Cmake/IccProfLib/Release/IccProfLib2-static.lib")
endif()

set(LINK_LIBS Mscms.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib)

target_link_options(${PROJECT_NAME} PRIVATE "/OUT:${OUTPUT_DIR}/DemoIccMAXCmm.dll" "/PDB:${OUTPUT_DIR}/DemoIccMAXCmm.pdb" "/DYNAMICBASE:NO" "/NODEFAULTLIB:LIBCMT")

target_link_libraries(${PROJECT_NAME} PRIVATE ${LINK_LIBS})

message(STATUS "Configuration complete for IccMAXCmm (Windows only).")
