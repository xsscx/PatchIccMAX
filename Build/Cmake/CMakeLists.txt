##############################################################################
## Top Level IccMAX Project Configuration in Build/Cmake/CMakeLists.txt ##
##############################################################################
# 
# Top Level Configuration CMakeLists.txt | IccMAX Project
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
# 
#
# Last Updated: 10-MAR-2025 1902 EDT by David Hoyt
#
# Changes:  Modified Build/Cmake/CMakelists.txt and others
#           Added to CMakelists.txt: iccPngDump,DemoIccMAXCmm
#           Adjusted Cross Platform Build Args
#						
# TODO: Refactor Debug, Release, Asan 
#       Housekeeping, Unix & Windows now Build from Cmake
#       Refactor Base Configs & logging to .mk's 
##############################################################################
## Top Level IccMAX Project Configuration in Build/Cmake/CMakeLists.txt ##
##############################################################################


# Include timestamp for logs
# Start Configuration Message
string(TIMESTAMP CURRENT_DATETIME "%Y-%m-%d %H:%M:%S")
message(STATUS "##########################################################################")
message(STATUS "## Starting to Configure the IccMAX Project at ${CURRENT_DATETIME}")
message(STATUS "##########################################################################")

cmake_minimum_required(VERSION 3.15)

# Project Configuration
project(RefIccMAX VERSION 2.1.25 LANGUAGES CXX)

# Set C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set Default Build Type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose build type: Debug, Release, Asan" FORCE)
endif()

# Verbose build only in Debug mode
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_VERBOSE_MAKEFILE ON)
endif()

# Package Metadata
set(PACKAGE_NAME "reficcmax")
set(PACKAGE_DESCRIPTION "The RefIccMAX project provides an open-source set of libraries and tools for ICC profile manipulation based on the iccMAX specification.")

# Output Version Information
message(STATUS "Configuring ${PROJECT_NAME} v${PROJECT_VERSION}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")


# Define the true project root directory
set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR}/../..)
# Debugging and Host System Details
message(STATUS "### System Information ###")
message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
message(STATUS "PROJECT_ROOT_DIR is resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "System Name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "System Version: ${CMAKE_SYSTEM_VERSION}")
message(STATUS "System Processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Build Host: $ENV{COMPUTERNAME} ($ENV{USERNAME})")

# Environment Information
message(STATUS "### Environment Information ###")
# Pretty-print the PATH environment variable with numbered entries
if(WIN32)
    set(PATH_SEPARATOR ";")  # Windows path separator
else()
    set(PATH_SEPARATOR ":")  # Unix-like systems path separator
endif()

# Split the PATH variable into a list
string(REPLACE "${PATH_SEPARATOR}" ";" PATH_LIST "$ENV{PATH}")
list(LENGTH PATH_LIST PATH_LENGTH)

# Generate numbered output
message(STATUS "### PATH Environment Variable ###")
foreach(INDEX RANGE 0 [expr ${PATH_LENGTH} - 1])
    list(GET PATH_LIST ${INDEX} PATH_ENTRY)
    message(STATUS "[${INDEX}] ${PATH_ENTRY}")
endforeach()

message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

# Compiler Information
message(STATUS "### Compiler Information ###")
message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ Compiler ID: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "C++ Compiler Version: ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C Compiler Version: ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "Linker: ${CMAKE_LINKER}")
message(STATUS "")

# Platform-Specific Details
if(APPLE)
    message(STATUS "### macOS Specific Details ###")
    message(STATUS "SDK Path: ${CMAKE_OSX_SYSROOT}")
    message(STATUS "Deployment Target: ${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()

if(WIN32)
    if(DEFINED ENV{MSBUILD_PATH})
        message(STATUS "MSBuild Path: $ENV{MSBUILD_PATH}")
    else()
        message(WARNING "MSBuild Path is not set. Run 'Get-ChildItem -Path \"C:\\Program Files\\Microsoft Visual Studio\" -Recurse -Filter \"MSBuild.exe\"' in PowerShell to find it.")
    endif()
endif()


if(UNIX AND NOT APPLE)
    message(STATUS "### Linux/Unix Specific Details ###")

    # Capture system info
    execute_process(COMMAND uname -a OUTPUT_VARIABLE SYSTEM_INFO OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND lsb_release -d OUTPUT_VARIABLE DISTRO_INFO ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

    message(STATUS "System Info: ${SYSTEM_INFO}")
    
    if(DISTRO_INFO)
        message(STATUS "Distribution: ${DISTRO_INFO}")
    else()
        message(WARNING "lsb_release not found, skipping distribution detection.")
    endif()

    message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER} (${CMAKE_CXX_COMPILER_ID} v${CMAKE_CXX_COMPILER_VERSION})")
    message(STATUS "Linker Flags: ${CMAKE_EXE_LINKER_FLAGS}")
endif()

# Cross-Platform Debugging
message(STATUS "### Cross-Platform Debugging Details ###")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "Build Generator: ${CMAKE_GENERATOR}")
message(STATUS "Build Tool: ${CMAKE_MAKE_PROGRAM}")

# Build Configuration
message(STATUS "### Build Configuration ###")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "C++ Flags (Global): ${CMAKE_CXX_FLAGS}")
message(STATUS "C Flags (Global): ${CMAKE_C_FLAGS}")

# Per-Build-Type Flags
string(TOUPPER "${CMAKE_BUILD_TYPE}" UPPER_BUILD_TYPE)
if(DEFINED CMAKE_CXX_FLAGS_${UPPER_BUILD_TYPE})
    message(STATUS "C++ Flags (${CMAKE_BUILD_TYPE}): ${CMAKE_CXX_FLAGS_${UPPER_BUILD_TYPE}}")
else()
    message(WARNING "No specific C++ flags set for build type '${CMAKE_BUILD_TYPE}'")
endif()

# Feature Configuration
message(STATUS "### Feature Configuration ###")
message(STATUS "Enable Tools: ${ENABLE_TOOLS}")
message(STATUS "Enable Tests: ${ENABLE_TESTS}")
message(STATUS "Enable Shared Libraries: ${BUILD_SHARED_LIBS}")
message(STATUS "Enable Static Libraries: ${ENABLE_STATIC_LIBS}")

# Dependencies
message(STATUS "### Dependencies ###")

find_package(LibXml2 REQUIRED)
message(STATUS "LibXml2: ${LIBXML2_LIBRARIES} (Version: ${LIBXML2_VERSION})")

find_package(nlohmann_json REQUIRED)
message(STATUS "nlohmann_json: ${nlohmann_json_DIR} (Version: ${nlohmann_json_VERSION})")

find_package(TIFF REQUIRED)
message(STATUS "TIFF: ${TIFF_LIBRARIES} (Version: ${TIFF_VERSION})")
message(STATUS "TIFF Include Directory: ${TIFF_INCLUDE_DIRS}")

find_package(PNG REQUIRED)
message(STATUS "PNG: ${PNG_LIBRARIES} (Version: ${PNG_VERSION})")
message(STATUS "PNG Include Directory: ${PNG_INCLUDE_DIRS}")


# Include Directories
message(STATUS "### Include Directories ###")
message(STATUS "IccProfLib: ${CMAKE_SOURCE_DIR}/IccProfLib")
message(STATUS "IccXML: ${CMAKE_SOURCE_DIR}/IccXML")
message(STATUS "PNG: ${PNG_INCLUDE_DIRS}")

# Link Directories
message(STATUS "### Link Directories ###")
message(STATUS "IccProfLib: ${CMAKE_BINARY_DIR}/IccProfLib")
message(STATUS "IccXML: ${CMAKE_BINARY_DIR}/IccXML")
message(STATUS "System Library Path: /usr/local/lib")

# Library paths for debugging
message(STATUS "Library Path for IccProfLib: ${CMAKE_BINARY_DIR}/IccProfLib")
message(STATUS "Library Path for IccXML: ${CMAKE_BINARY_DIR}/IccXML")

# CI/CD Integration Information
if(DEFINED ENV{CI})
    message(STATUS "### CI/CD Details ###")
    message(STATUS "CI/CD Detected: $ENV{CI}")
    message(STATUS "Build Number: $ENV{BUILD_NUMBER}")
    message(STATUS "Branch: $ENV{BRANCH_NAME}")
    message(STATUS "Commit: $ENV{GIT_COMMIT}")
    message(STATUS "Pipeline URL: $ENV{CI_PIPELINE_URL}")
else()
    message(STATUS "CI/CD Integration: Not Detected")    
endif()

# Install Directories and GNUInstallDirs
message(STATUS "Initializing GNUInstallDirs.")
include(GNUInstallDirs)

# Build Options
option(ENABLE_TESTS "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS "Build tools" ON)
option(ENABLE_SHARED_LIBS "Build dynamic link libraries" ON)
option(ENABLE_STATIC_LIBS "Build static libraries" ON)
option(ENABLE_ICCXML "Build IccXML library" ON)

# Configure Install Behavior
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
    option(ENABLE_INSTALL_RIM "Install files" ON)
else()
    message(STATUS "Compiling RefIccMAX as a subproject - skipping installation (ENABLE_INSTALL_RIM=OFF)")
    set(ENABLE_INSTALL_RIM OFF)
    set(ENABLE_STATIC_LIBS ON)
    set(ENABLE_SHARED_LIBS OFF)
endif()

# Enforce Build Type
message(STATUS "Enforcing Build Type in ${CMAKE_CURRENT_SOURCE_DIR}")
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

# Compiler Flags
message(STATUS "Setting Compiler Flags in ${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -fsanitize=address -fno-omit-frame-pointer -Wall -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")

# Architecture and Platform Detection
if(APPLE)
    message(STATUS "Detected platform: macOS")

    execute_process(
        COMMAND uname -m
        OUTPUT_VARIABLE OSX_ARCHITECTURE
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(OSX_ARCHITECTURE STREQUAL "arm64")
        message(STATUS "Configuring build for ARM64 architecture.")
        set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "macOS architecture")
        add_compile_definitions(ARM64)
    elseif(OSX_ARCHITECTURE STREQUAL "x86_64")
        message(STATUS "Configuring build for X86_64 architecture.")
        set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "macOS architecture")
    else()
        message(FATAL_ERROR "Unsupported macOS architecture: ${OSX_ARCHITECTURE}")
    endif()

    message(STATUS "Final macOS Architecture: ${CMAKE_OSX_ARCHITECTURES}")

elseif(UNIX AND NOT APPLE)
    message(STATUS "Detected platform: Linux")

    execute_process(
        COMMAND uname -m
        OUTPUT_VARIABLE LINUX_ARCHITECTURE
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    message(STATUS "Configuring build for ${LINUX_ARCHITECTURE} architecture.")
    add_compile_options(-std=c++17 -Wall -Wextra -Wpedantic)
    add_compile_definitions(PLATFORM_LINUX)

    message(STATUS "Linux build: Compiler flags set to C++17 with standard warnings.")

elseif(WIN32)
    message(STATUS "Detected platform: Windows")

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(WINDOWS_ARCH "x64")
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(WINDOWS_ARCH "x86")
    else()
        set(WINDOWS_ARCH "unknown")
    endif()

    message(STATUS "Configuring build for Windows (${WINDOWS_ARCH})")

    add_compile_options(/std:c++17 /D_WINDOWS /EHsc)
    add_compile_definitions(PLATFORM_WINDOWS)

    message(STATUS "Windows build: Compiler flags set to C++17 with MSVC-specific flags.")

else()
    message(FATAL_ERROR "Unsupported platform detected!")
endif()

message(STATUS "Debug Configuration")
# Debug configuration
if(CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]")
  message("-- Info: Debug build \"${CMAKE_BUILD_TYPE}\"")
  set(DEBUG 1)
  add_definitions(-D_DEBUG)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
endif()

message(STATUS "Sanitizer Configuration")
# Sanitizer support (Optional, for Linux/Unix-like systems)
if(UNIX AND NOT APPLE AND CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address,undefined -fno-omit-frame-pointer")
  message(STATUS "Sanitizers enabled for Debug build.")
endif()

#
# Target installation folders
#

SET (TARGET_INCLUDE_FOLDER
    ${PROJECT_NAME}
    CACHE STRING
    "Optional folder below system include folder to install include files."
    )

IF(NOT CMAKE_MODULES_INSTALL_DIR)
  SET (CMAKE_MODULES_INSTALL_DIR
    "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_DOWN_NAME}"
    CACHE STRING
    "The folder where to install cmake files."
    )
ENDIF(NOT CMAKE_MODULES_INSTALL_DIR)


SET (TARGET_PKGCONFIG_FOLDER
    "pkgconfig"
    CACHE STRING
    "The folder below system library folder where to install pkgconfig files."
    )

SET (TARGET_DOCUMENTATION_FOLDER
    "share/doc/${PACKAGE_NAME}-api"
    CACHE STRING
    "The folder below system prefix where to install api documentation files."
    )

# additional cmake modules for loading libraries
SET (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/Modules/")


SET( TOP_SOURCE_DIR ../.. )
INCLUDE_DIRECTORIES ( ${TOP_SOURCE_DIR}/IccProfLib/ )

# external dependencies
FIND_PROGRAM(CMAKE_AR_TMP NAMES ar)

#
# Core library
#
message(STATUS "Adding subdirectory for IccProfLib.")
ADD_SUBDIRECTORY( IccProfLib )
SET( TARGET_LIB_ICCPROFLIB ${TARGET_LIB} )


## external dependency
IF(ENABLE_ICCXML)
  IF(USE_SYSTEM_LIBXML2)
    FIND_PACKAGE(LibXML2 REQUIRED)
  ELSE()
    FIND_PACKAGE(LibXML2)
  ENDIF()
  IF(LIBXML2_FOUND)
    INCLUDE_DIRECTORIES( ${LIBXML2_INCLUDE_DIR} )
    LINK_DIRECTORIES( ${LIBXML2_LIBRARY_DIRS} )
    SET( HAVE_LIBXML2 1 )
  ELSE( LIBXML2_FOUND )
    IF(CMAKE_VERSION VERSION_GREATER 2.8.0)
      SET( HAVE_LIBXML2 TRUE  )
      INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/IccXML/libxml2 )
      LINK_DIRECTORIES( ${CMAKE_CURRENT_BINARY_DIR}/IccXML/libxml2 )
      ADD_SUBDIRECTORY( IccXML/libxml2 )
      SET( LIBXML2_LIBRARIES xml2-static )
    ENDIF()
  ENDIF(LIBXML2_FOUND)

  #
  # XML library
  #
  message(STATUS "Adding subdirectory for IccXML.")
  ADD_SUBDIRECTORY( IccXML )
  SET( TARGET_LIB_ICCXML ${TARGET_LIB} )
  INCLUDE_DIRECTORIES ( ${TOP_SOURCE_DIR}/IccXML/IccLibXML/ )
ENDIF()

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
  message(STATUS "Adding Subdirectory IccDumpProfile.")
  ADD_SUBDIRECTORY(Tools/IccDumpProfile)
  message(STATUS "Adding Subdirectory IccDumpRoundTrip.")
  ADD_SUBDIRECTORY(Tools/IccRoundTrip)
  message(STATUS "Adding Subdirectory IccFromCube.")
  ADD_SUBDIRECTORY(Tools/IccFromCube)
  message(STATUS "Adding Subdirectory IccV5DspObsToV4Dsp.")
  ADD_SUBDIRECTORY(Tools/IccV5DspObsToV4Dsp)
  message(STATUS "Adding Subdirectory IccApplyToLink.")
  ADD_SUBDIRECTORY(Tools/IccApplyToLink)
  
# Add PNG Tools

# Check for PNG library
find_package(PNG REQUIRED)

if (PNG_FOUND)
    include_directories(${PNG_INCLUDE_DIRS})
    message(STATUS "PNG library found: ${PNG_LIBRARIES}")

    message(STATUS "Adding Subdirectory IccPngDump.")
    ADD_SUBDIRECTORY(Tools/IccPngDump)
else()
    message(FATAL_ERROR "PNG library not found. Please install libpng-dev.")
endif()
  


    message(STATUS "Adding Subdirectory DemoIccMAXCmm.")
    ADD_SUBDIRECTORY(Tools/DemoIccMAXCmm)

  # Check for TIFF library
  find_package(TIFF REQUIRED)
  if (TIFF_FOUND)
    include_directories(${TIFF_INCLUDE_DIR})
    message(STATUS "TIFF library found: ${TIFF_LIBRARIES}")
    
    # Add TIFF-dependent tools
#    ADD_SUBDIRECTORY(Tools/IccApplyProfiles)
    message(STATUS "Adding subdirectory IccSpecSepToTiff.")
    ADD_SUBDIRECTORY(Tools/IccSpecSepToTiff)
    message(STATUS "Adding Subdirectory IccTiffDump.")
    ADD_SUBDIRECTORY(Tools/IccTiffDump)
  else()
    message(FATAL_ERROR "TIFF library not found. Please install libtiff-dev.")
  endif()

  # Add XML-related tools
  message(STATUS "Adding Subdirectory IccFromXml.")
  ADD_SUBDIRECTORY(Tools/IccFromXml)
  message(STATUS "Adding Subdirectory IccToXml.")
  ADD_SUBDIRECTORY(Tools/IccToXml)
#   message(STATUS "Adding Subdirectory iccDumpProfilegui.")
#  ADD_SUBDIRECTORY(Tools/wxProfileDump)

#  # Configure wxWidgets
  find_package(wxWidgets COMPONENTS core base REQUIRED)
  if (wxWidgets_FOUND)
    include(${wxWidgets_USE_FILE})
    ADD_SUBDIRECTORY(Tools/wxProfileDump)
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
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccApplyToLink ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfile ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfileGui ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/ || echo ""
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromXML ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromCube ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccToXml ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccRoundTrip ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccSpecSepToTiff ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccTiffDump ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccPngDump ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccV5DspObsToV4Dsp ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
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
