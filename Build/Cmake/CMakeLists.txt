# 
# Top Level Configuration CMakeLists.txt | DemoIccMAX Project
# Copyright (c) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 2024-11-24 by David Hoyt
#
# Changes: 	Added JSON Dependency
#						Adjusted Cross Platform Build Args
#						
# TODO: Refactor Debug, Release, Asan 
# 			Collapse 3-tier CMakeLists.txt, Housekeeping
#				Refactor Base Configs & logging to .mk's 
#

cmake_minimum_required(VERSION 2.8.5)

# Include timestamp for logs
string(TIMESTAMP CURRENT_DATETIME "%Y-%m-%d %H:%M:%S")
message(STATUS "##########################################################################")
message(STATUS "## Starting Configuration for DemoIccMAX Project at ${CURRENT_DATETIME}")
message(STATUS "##########################################################################")

# Project Configuration
project(RefIccMAX)
set(PROJECT_UP_NAME "REFICCMAX")
set(CMAKE_CXX_STANDARD 17)

set(${PROJECT_UP_NAME}_MAJOR_VERSION 2)
set(${PROJECT_UP_NAME}_MINOR_VERSION 1)
set(${PROJECT_UP_NAME}_MICRO_VERSION 25)
set(${PROJECT_UP_NAME}_VERSION
    "${${PROJECT_UP_NAME}_MAJOR_VERSION}.${${PROJECT_UP_NAME}_MINOR_VERSION}.${${PROJECT_UP_NAME}_MICRO_VERSION}"
)

set(PROJECT_DOWN_NAME "reficcmax")
set(PACKAGE_NAME "${PROJECT_DOWN_NAME}")
set(PACKAGE_DESCRIPTION "The RefIccMAX project provides an open source set of libraries and tools that allow for the interaction, manipulation, and application of iccMAX-based color management profiles based on the iccMAX specification http://www.color.org/iccmax.xalter, in addition to legacy ICC profiles defined by earlier ICC specifications.")

set(${PROJECT_NAME}_VERSION_MAJORMINOR
    "${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}"
)

# Define the true project root directory
set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR}/../..)

# Debugging and Host System Details
message(STATUS "### System Information ###")
message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
message(STATUS "PROJECT_ROOT_DIR: ${CMAKE_SOURCE_DIR}/..")
message(STATUS "System Name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "System Version: ${CMAKE_SYSTEM_VERSION}")
message(STATUS "System Processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Build Host: $ENV{COMPUTERNAME} ($ENV{USERNAME})")
message(STATUS "")

# Environment Information
message(STATUS "### Environment Information ###")
message(STATUS "PATH: $ENV{PATH}")
message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(STATUS "")

# Compiler Information
message(STATUS "### Compiler Information ###")
message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ Compiler Version: ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C Compiler Version: ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "Linker: ${CMAKE_LINKER}")
message(STATUS "")

# macOS Specific Details
if(APPLE)
    message(STATUS "### macOS Specific Details ###")
    message(STATUS "macOS SDK Path: ${CMAKE_OSX_SYSROOT}")
    message(STATUS "Deployment Target: ${CMAKE_OSX_DEPLOYMENT_TARGET}")
    message(STATUS "")
endif()

# Windows Specific Details
if(WIN32)
    message(STATUS "### Windows Specific Details ###")
    message(STATUS "Windows SDK Version: ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}")
    message(STATUS "MSBuild Path: $ENV{MSBUILD_PATH}")
    message(STATUS "")
endif()

# Build Configuration
message(STATUS "### Build Configuration ###")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "C++ Flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "C Flags: ${CMAKE_C_FLAGS}")
message(STATUS "Linker Flags: ${CMAKE_EXE_LINKER_FLAGS}")
message(STATUS "")

# Features Enabled/Disabled
message(STATUS "### Feature Configuration ###")
message(STATUS "Enable Tools: ${ENABLE_TOOLS}")
message(STATUS "Enable Tests: ${ENABLE_TESTS}")
message(STATUS "Enable Shared Libraries: ${ENABLE_SHARED_LIBS}")
message(STATUS "Enable Static Libraries: ${ENABLE_STATIC_LIBS}")
message(STATUS "")

# CI/CD Integration Information
if(DEFINED ENV{CI})
    message(STATUS "### CI/CD Details ###")
    message(STATUS "CI/CD Detected: $ENV{CI}")
    message(STATUS "Build Number: $ENV{BUILD_NUMBER}")
    message(STATUS "Branch: $ENV{BRANCH_NAME}")
    message(STATUS "Commit: $ENV{GIT_COMMIT}")
    message(STATUS "Pipeline URL: $ENV{CI_PIPELINE_URL}")
    message(STATUS "")
else()
    message(STATUS "CI/CD Integration: Not Detected")
endif()

# Dependency Information
message(STATUS "### Dependency Information ###")
if(EXISTS "${CMAKE_SOURCE_DIR}/vcpkg.json")
    message(STATUS "vcpkg Manifest Detected")
    execute_process(COMMAND ${CMAKE_COMMAND} -P "${CMAKE_SOURCE_DIR}/scripts/vcpkg_status.cmake"
                    OUTPUT_VARIABLE VCPKG_STATUS
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    message(STATUS "${VCPKG_STATUS}")
else()
    message(STATUS "No vcpkg manifest found. Ensure dependencies are resolved manually.")
endif()

# Dependencies
message(STATUS "##########################################################################")
message(STATUS "### Dependencies ###")
message(STATUS "##########################################################################")

# Find required packages
find_package(LibXml2 REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(TIFF REQUIRED)

# Dependency Logging
if(LibXml2_FOUND)
    message(STATUS "LibXml2: ${LIBXML2_LIBRARIES} (found version ${LIBXML2_VERSION})")
else()
    message(FATAL_ERROR "LibXml2 not found. Ensure it is installed and accessible.")
endif()

if(nlohmann_json_FOUND)
    message(STATUS "nlohmann_json: ${nlohmann_json_DIR} (found version ${nlohmann_json_VERSION})")
else()
    message(FATAL_ERROR "nlohmann_json not found. Ensure it is installed and accessible.")
endif()

if(TIFF_FOUND)
    message(STATUS "TIFF: ${TIFF_LIBRARIES} (found version ${TIFF_VERSION})")
    message(STATUS "TIFF Include Directory: ${TIFF_INCLUDE_DIR}")
else()
    message(FATAL_ERROR "TIFF not found. Ensure it is installed and accessible.")
endif()

message(STATUS "")

# Include Directories
message(STATUS "##########################################################################")
message(STATUS "### Include Directories ###")
message(STATUS "##########################################################################")
message(STATUS "IccProfLib: ${PROJECT_ROOT_DIR}/IccProfLib")
message(STATUS "IccXML: ${PROJECT_ROOT_DIR}/IccXML")
message(STATUS "")

# Link Directories
message(STATUS "##########################################################################")
message(STATUS "### Link Directories ###")
message(STATUS "##########################################################################")
message(STATUS "IccProfLib: ${CMAKE_BINARY_DIR}/IccProfLib")
message(STATUS "IccXML: ${CMAKE_BINARY_DIR}/IccXML")
message(STATUS "/usr/local/lib")
message(STATUS "")

# Library Paths for Debugging
message(STATUS "##########################################################################")
message(STATUS "### Library Paths ###")
message(STATUS "##########################################################################")
message(STATUS "Library Path for IccProfLib: ${PROJECT_ROOT_DIR}/Build/IccProfLib")
message(STATUS "Library Path for IccXML: ${PROJECT_ROOT_DIR}/Build/IccXML")
message(STATUS "")

# Build Options
message(STATUS "##########################################################################")
message(STATUS "### Build Options ###")
message(STATUS "##########################################################################")
include(GNUInstallDirs)

option(ENABLE_TESTS "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS "Build tools" ON)
option(ENABLE_SHARED_LIBS "Build dynamic link libs" ON)
option(ENABLE_STATIC_LIBS "Build static libs" ON)
option(ENABLE_ICCXML "Build IccXML library" ON)

# Log Build Options
message(STATUS "ENABLE_TESTS: ${ENABLE_TESTS}")
message(STATUS "ENABLE_TOOLS: ${ENABLE_TOOLS}")
message(STATUS "ENABLE_SHARED_LIBS: ${ENABLE_SHARED_LIBS}")
message(STATUS "ENABLE_STATIC_LIBS: ${ENABLE_STATIC_LIBS}")
message(STATUS "ENABLE_ICCXML: ${ENABLE_ICCXML}")
message(STATUS "")

include(GNUInstallDirs)

# Build Options
message(STATUS "##########################################################################")
message(STATUS "### Build Options ###")
message(STATUS "##########################################################################")

option(ENABLE_TESTS "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS "Build tools" ON)
option(ENABLE_SHARED_LIBS "Build dynamic link libs" ON)
option(ENABLE_STATIC_LIBS "Build static libs" ON)
option(ENABLE_ICCXML "Build IccXML library" ON)

# Subproject Configuration
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
    option(ENABLE_INSTALL_RIM "Install files" ON)
else()
    message(STATUS "-- RefIccMAX: Compiled as a subproject - skipping install (ENABLE_INSTALL_RIM=OFF)")
    set(ENABLE_INSTALL_RIM OFF CACHE BOOL "Install disabled for subproject" FORCE)

    # Adjust library settings for fallback subproject
    set(ENABLE_STATIC_LIBS ON CACHE BOOL "Static libraries enabled for fallback subproject" FORCE)
    set(ENABLE_SHARED_LIBS OFF CACHE BOOL "Shared libraries disabled for fallback subproject" FORCE)
endif()

# Log Build Options
message(STATUS "ENABLE_TESTS: ${ENABLE_TESTS}")
message(STATUS "ENABLE_TOOLS: ${ENABLE_TOOLS}")
message(STATUS "ENABLE_SHARED_LIBS: ${ENABLE_SHARED_LIBS}")
message(STATUS "ENABLE_STATIC_LIBS: ${ENABLE_STATIC_LIBS}")
message(STATUS "ENABLE_ICCXML: ${ENABLE_ICCXML}")
message(STATUS "ENABLE_INSTALL_RIM: ${ENABLE_INSTALL_RIM}")
message(STATUS "")

# Enforce Default Build Type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build (e.g., Debug, Release)." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not specified, defaulting to Debug for symbol inclusion.")
else()
    message(STATUS "CMAKE_BUILD_TYPE explicitly set to: ${CMAKE_BUILD_TYPE}")
endif()
message(STATUS "")

# Compiler Flags
message(STATUS "##########################################################################")
message(STATUS "### Compiler Flags ###")
message(STATUS "##########################################################################")

# Cross-platform handling for debug and release flags
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -fsanitize=address -fno-omit-frame-pointer -Wall -O0")
    message(STATUS "Debug flags applied: ${CMAKE_CXX_FLAGS_DEBUG}")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
    message(STATUS "Release flags applied: ${CMAKE_CXX_FLAGS_RELEASE}")
endif()
message(STATUS "")

# Display summary of enforced build type and flags
message(STATUS "Final CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
message(STATUS "CXX Flags for Debug: ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "CXX Flags for Release: ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "")

# Architecture determination
message(STATUS "##########################################################################")
message(STATUS "### Architecture and Platform Determination ###")
message(STATUS "##########################################################################")

if(APPLE)
    execute_process(
        COMMAND uname -m
        COMMAND tr -d '\n'
        OUTPUT_VARIABLE OSX_ARCHITECTURE
    )
    message(STATUS "Detected macOS architecture: ${OSX_ARCHITECTURE}")
    if("${OSX_ARCHITECTURE}" STREQUAL "arm64")
        add_definitions(-DARM64)
        message(STATUS "Configuring build for ARM64 architecture.")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch arm64")
    elseif("${OSX_ARCHITECTURE}" STREQUAL "x86_64")
        message(STATUS "Configuring build for X86_64 architecture.")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch x86_64")
    else()
        message(FATAL_ERROR "Unsupported macOS architecture: ${OSX_ARCHITECTURE}")
    endif()
elseif(UNIX AND NOT APPLE)
    execute_process(
        COMMAND uname -m
        COMMAND tr -d '\n'
        OUTPUT_VARIABLE LINUX_ARCHITECTURE
    )
    message(STATUS "Detected Linux architecture: ${LINUX_ARCHITECTURE}")
    if("${LINUX_ARCHITECTURE}" STREQUAL "aarch64")
        add_definitions(-DARM64)
        message(STATUS "Configuring build for ARM64 architecture.")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8-a")
    elseif("${LINUX_ARCHITECTURE}" STREQUAL "x86_64")
        message(STATUS "Configuring build for X86_64 architecture.")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=x86-64")
    else()
        message(FATAL_ERROR "Unsupported Linux architecture: ${LINUX_ARCHITECTURE}")
    endif()
elseif(WIN32)
    message(STATUS "Configuring build for Windows.")
    if(CMAKE_GENERATOR_PLATFORM MATCHES "ARM64")
        add_definitions(-DARM64)
        message(STATUS "Configuring build for ARM64 architecture on Windows.")
    else()
        message(STATUS "Configuring build for X86_64 architecture on Windows.")
    endif()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /D_WINDOWS /EHsc")
else()
    message(FATAL_ERROR "Unsupported platform!")
endif()

message(STATUS "")

# Debug configuration
message(STATUS "##########################################################################")
message(STATUS "### Debug Configuration ###")
message(STATUS "##########################################################################")

if(CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]")
    message(STATUS "Info: Debug build \"${CMAKE_BUILD_TYPE}\" detected.")
    set(DEBUG 1)
    add_definitions(-D_DEBUG)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
    if(UNIX AND NOT APPLE)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address,undefined -fno-omit-frame-pointer")
        message(STATUS "Sanitizers enabled for Debug build on Linux.")
    endif()
endif()

# Summary
message(STATUS "Final architecture-specific flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "")

##########################################################################
### Target Installation Folders
##########################################################################

# Folder for include files
set(TARGET_INCLUDE_FOLDER
    ${PROJECT_NAME}
    CACHE STRING
    "Optional folder below the system include folder to install include files."
)
message(STATUS "Target Include Folder: ${TARGET_INCLUDE_FOLDER}")

# Folder for CMake module installation
if(NOT CMAKE_MODULES_INSTALL_DIR)
    set(CMAKE_MODULES_INSTALL_DIR
        "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
        CACHE STRING
        "The folder where CMake files will be installed."
    )
endif()
message(STATUS "CMake Modules Install Directory: ${CMAKE_MODULES_INSTALL_DIR}")

# Folder for pkgconfig files
set(TARGET_PKGCONFIG_FOLDER
    "pkgconfig"
    CACHE STRING
    "The folder below the system library folder to install pkgconfig files."
)
message(STATUS "Target PkgConfig Folder: ${TARGET_PKGCONFIG_FOLDER}")

# Folder for API documentation
set(TARGET_DOCUMENTATION_FOLDER
    "share/doc/${PROJECT_NAME}-api"
    CACHE STRING
    "The folder below the system prefix to install API documentation files."
)
message(STATUS "Target Documentation Folder: ${TARGET_DOCUMENTATION_FOLDER}")

##########################################################################
### Additional CMake Modules and Paths
##########################################################################

# Add additional CMake modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/Modules/")
message(STATUS "CMake Module Path: ${CMAKE_MODULE_PATH}")

# Include directories for source files
set(TOP_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../..)
include_directories(${TOP_SOURCE_DIR}/IccProfLib)
message(STATUS "Top Source Directory: ${TOP_SOURCE_DIR}")
message(STATUS "Included Directory: ${TOP_SOURCE_DIR}/IccProfLib")

##########################################################################
### External Dependencies
##########################################################################

# Find 'ar' program for creating archives
find_program(CMAKE_AR_TMP NAMES ar)
if(CMAKE_AR_TMP)
    message(STATUS "Archiver 'ar' found at: ${CMAKE_AR_TMP}")
else()
    message(WARNING "Archiver 'ar' not found. Ensure it is installed for static library builds.")
endif()

##########################################################################
### Core Library
##########################################################################

# Add core library subdirectory
add_subdirectory(IccProfLib)
set(TARGET_LIB_ICCPROFLIB ${TARGET_LIB})
message(STATUS "Core library 'IccProfLib' added.")
message(STATUS "Core library target: ${TARGET_LIB_ICCPROFLIB}")
message(STATUS "")

##########################################################################
### External Dependency: LibXML2
##########################################################################

if(ENABLE_ICCXML)
    message(STATUS "ICCXML support is enabled.")

    # Check for system-provided LibXML2 or fallback to bundled version
    if(USE_SYSTEM_LIBXML2)
        find_package(LibXML2 REQUIRED)
    else()
        find_package(LibXML2)
    endif()

    if(LIBXML2_FOUND)
        message(STATUS "LibXML2 found: ${LIBXML2_LIBRARIES}")
        include_directories(${LIBXML2_INCLUDE_DIR})
        link_directories(${LIBXML2_LIBRARY_DIRS})
        set(HAVE_LIBXML2 1)
    else()
        message(WARNING "LibXML2 not found in the system. Falling back to bundled version.")
        if(CMAKE_VERSION VERSION_GREATER 2.8.0)
            set(HAVE_LIBXML2 TRUE)
            include_directories(${CMAKE_CURRENT_SOURCE_DIR}/IccXML/libxml2)
            link_directories(${CMAKE_CURRENT_BINARY_DIR}/IccXML/libxml2)
            add_subdirectory(IccXML/libxml2)
            set(LIBXML2_LIBRARIES xml2-static)
            message(STATUS "Bundled LibXML2 added as 'xml2-static'.")
        else()
            message(FATAL_ERROR "LibXML2 is required but not found.")
        endif()
    endif()

    ##########################################################################
    ### XML Library
    ##########################################################################

    # Add XML library subdirectory
    add_subdirectory(IccXML)
    set(TARGET_LIB_ICCXML ${TARGET_LIB})
    include_directories(${TOP_SOURCE_DIR}/IccXML/IccLibXML/)
    message(STATUS "XML library 'IccXML' added.")
    message(STATUS "XML library target: ${TARGET_LIB_ICCXML}")
else()
    message(STATUS "ICCXML support is disabled.")
endif()

message(STATUS "")

# Ensure nlohmann_json is found
find_package(nlohmann_json REQUIRED)
message(STATUS "nlohmann_json library found: ${nlohmann_json_DIR}")

IF(ENABLE_TOOLS)
  # Verify nlohmann_json is configured properly
  IF(nlohmann_json_DIR)
    MESSAGE(STATUS "Found nlohmann JSON library at: ${nlohmann_json_DIR}")

    # Use nlohmann_json include directory
    include_directories(${nlohmann_json_DIR})

 message(STATUS "Adding IccApplyNamedCmm from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")

# Add subdirectory for IccApplyNamedCmm
IF(EXISTS "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")
  add_subdirectory(
    ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm
    ${CMAKE_BINARY_DIR}/Tools/CmdLine/IccApplyNamedCmm_Build
  )
  message(STATUS "Added IccApplyNamedCmm")
ELSE()
  message(FATAL_ERROR "Directory does not exist: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")
ENDIF()

    # Add IccApplyProfiles
    MESSAGE(STATUS "Adding IccApplyProfiles from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
    IF(EXISTS "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
      add_subdirectory(
        ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles
        ${CMAKE_BINARY_DIR}/Tools/CmdLine/IccApplyProfiles_Build
      )
      MESSAGE(STATUS "Added IccApplyProfiles")
    ELSE()
      message(FATAL_ERROR "Directory does not exist: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
    ENDIF()
  ELSE()
    MESSAGE(WARNING "nlohmann JSON library not found. Skipping Tools/IccApplyNamedCmm and Tools/IccApplyProfiles.")
    RETURN() # Exit script for tools if dependency is not found
  ENDIF()

  # Add remaining tools
  ADD_SUBDIRECTORY(Tools/IccDumpProfile)
  ADD_SUBDIRECTORY(Tools/IccRoundTrip)

  # Check for TIFF library
  find_package(TIFF REQUIRED)
  if (TIFF_FOUND)
    include_directories(${TIFF_INCLUDE_DIR})
    message(STATUS "TIFF library found: ${TIFF_LIBRARIES}")
    
    # Add TIFF-dependent tools
#    ADD_SUBDIRECTORY(Tools/IccApplyProfiles)
    ADD_SUBDIRECTORY(Tools/IccSpecSepToTiff)
    ADD_SUBDIRECTORY(Tools/IccTiffDump)
  else()
    message(FATAL_ERROR "TIFF library not found. Please install libtiff-dev.")
  endif()

  # Add XML-related tools
  ADD_SUBDIRECTORY(Tools/IccFromXml)
  ADD_SUBDIRECTORY(Tools/IccToXml)

  # Configure wxWidgets
  find_package(wxWidgets COMPONENTS core base REQUIRED)
  if (wxWidgets_FOUND)
    include(${wxWidgets_USE_FILE})
    message(STATUS "wxWidgets found and configured")
  else()
    message(FATAL_ERROR "wxWidgets not found. Please install it manually or via vcpkg.")
  endif()

ENDIF(ENABLE_TOOLS)


# Optionally add a description for the option
option(ENABLE_FUZZING "Enable fuzzing sanitizer" OFF)

if(ENABLE_FUZZING)
    message(STATUS "Fuzzing enabled")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=fuzzer")
endif()

IF( ENABLE_TESTS )
  ADD_SUBDIRECTORY( Testing )
ENDIF( ENABLE_TESTS )

CONFIGURE_FILE(
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake"
    IMMEDIATE @ONLY)

ADD_CUSTOM_TARGET( uninstall
  "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake")

IF( CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64" )
  SET( ARCH 64 )
ELSE()
  SET( ARCH 32 )
ENDIF()
IF( NOT CMAKE_SYSTEM_NAME MATCHES Darwin )
  SET( GNUTAR_OPTS "--owner user:1000 --group group:500" )
ENDIF()
MESSAGE( "Configured ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}" )

ADD_CUSTOM_TARGET( dist-bin
    COMMAND test -d bin-temp && rm -rv bin-temp || echo "start fresh"
    COMMAND mkdir bin-temp && cd bin-temp && cmake -DENABLE_STATIC_LIBS=ON -DENABLE_SHARED_LIBS=OFF ${CMAKE_SOURCE_DIR} && make -j8 && make dist-bin2
    COMMAND ls -l bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing
    COMMAND echo "Dependencies for iccTiffDump:"
    COMMAND test ${CMAKE_SYSTEM_NAME} = Linux && ldd bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/iccTiffDump || echo ""
    COMMAND test ${CMAKE_SYSTEM_NAME} = Darwin && otool -L bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/iccTiffDump || echo ""
    COMMAND rm -r bin-temp
    COMMAND tar tzvf ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMAND echo "We are in:"
    COMMAND pwd
    COMMAND ls -l ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMENT Make a ${PROJECT_NAME} binary package
    VERBATIM
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    )

ADD_CUSTOM_TARGET( dist-bin2
    DEPENDS check
    COMMAND mkdir -p ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/IccApplyNamedCmm ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccApplyProfiles ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfile ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfileGui ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/ || echo ""
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromXML ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccToXml ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccRoundTrip ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccSpecSepToTiff ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccTiffDump ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/CreateAllProfiles.sh ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/RunTests.sh ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND echo tar cf - ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/ --owner user:1000 --group group:500 | gzip -9 > ../${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMAND tar cf - ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/ ${GNUTAR_OPTS} | gzip -9 > ../${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
                COMMENT Helper for making a ${PROJECT_NAME} binary package
                VERBATIM
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
                )

#
# Misc.
#

#cmake settings for use by find_package
CONFIGURE_FILE (
                "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Config.cmake.in"
                "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
                @ONLY
        )

IF(ENABLE_INSTALL_RIM)
  INSTALL ( FILES
                "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
                DESTINATION ${CMAKE_MODULES_INSTALL_DIR} COMPONENT dev
        )
ENDIF(ENABLE_INSTALL_RIM)

message(STATUS "##########################################################################")
message(STATUS "## Configuration Complete at ${CURRENT_DATETIME}")
message(STATUS "##########################################################################")


