#
# Configuration for IccMAXCmm in Build/Cmake/Tools/DemoIccMAXCmm/CMakeLists.txt
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Last Updated: 10-MAR-2025 2131 EDT by David Hoyt
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

# Detect OS and Set Source Paths
if (WIN32)
    message(STATUS "Configuring for Windows...")
    set(OS_SPECIFIC_SOURCES "${CMAKE_CURRENT_LIST_DIR}/../../../../Tools/Winnt/DemoIccMAXCmm")
elseif(APPLE OR UNIX)
    message(STATUS "Configuring for UNIX-based OS...")
    set(OS_SPECIFIC_SOURCES "${CMAKE_CURRENT_LIST_DIR}/../../../../Tools/Unix/DemoIccMAXCmm")
    if (NOT EXISTS "${OS_SPECIFIC_SOURCES}")
        message(WARNING "Unix-specific sources missing, falling back to Windows sources.")
        set(OS_SPECIFIC_SOURCES "${CMAKE_CURRENT_LIST_DIR}/../../../../Tools/Winnt/DemoIccMAXCmm")
    endif()
else()
    message(FATAL_ERROR "Unsupported operating system.")
endif()

# Compiler Settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_VERBOSE_MAKEFILE ON)

# Output Directory
set(OUTPUT_DIR "${CMAKE_BINARY_DIR}/Tools/DemoIccMAXCmm/x64/Release")
file(MAKE_DIRECTORY ${OUTPUT_DIR})

# Source Files
set(SOURCES
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.cpp"
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.rc"
    "${OS_SPECIFIC_SOURCES}/resource.h"
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.h"
)

# Windows-specific files
if (WIN32)
    list(APPEND SOURCES "${OS_SPECIFIC_SOURCES}/stdafx.cpp" "${OS_SPECIFIC_SOURCES}/stdafx.h")
endif()

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
    target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32 NDEBUG _WINDOWS _USRDLL DemoIccMAXCmm_EXPORTS _MBCS)
endif()

# Include Directories
include_directories(${OS_SPECIFIC_SOURCES} ${TOP_SOURCE_DIR}/IccProfLib)

# Library Linking
if (WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE "C:/test/DemoIccMAX/Build/win/n/IccProfLib/Release/IccProfLib.lib")
    set(LINK_LIBS Mscms.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib)
    target_link_options(${PROJECT_NAME} PRIVATE "/OUT:${OUTPUT_DIR}/DemoIccMAXCmm.dll" "/PDB:${OUTPUT_DIR}/DemoIccMAXCmm.pdb" "/DYNAMICBASE:NO" "/NODEFAULTLIB:LIBCMT")
elseif (APPLE OR UNIX)
    find_library(ICCPROFLIB iccproflib PATHS /usr/local/lib /usr/lib /home/xss/tmp/pr116/tmp/msvc/PatchIccMAX/Build/libs)
    
    if (ICCPROFLIB)
        message(STATUS "Found ICCPROFLIB: ${ICCPROFLIB}")
        target_link_libraries(${PROJECT_NAME} PRIVATE ${ICCPROFLIB} pthread dl)
    else()
        message(WARNING "ICCPROFLIB not found. The build may fail if required.")
    endif()

    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".so")
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE ${LINK_LIBS})


message(STATUS "#################### Exiting IccMAXCmm ####################")
