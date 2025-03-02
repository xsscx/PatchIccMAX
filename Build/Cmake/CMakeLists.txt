# 
# Top Level Configuration CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 02-DEC-2024 by David Hoyt
#
# Changes: 	Modified Build/Cmake/CMakelists.txt and others
#           Added to CMakelists.txt: IccFromCubeProject, IccV5DspObsToV4Dsp, IccApplyTolink
#           Adjusted Cross Platform Build Args
#						
# TODO: Refactor Debug, Release, Asan 
#       Collapse 3-tier CMakeLists.txt, Housekeeping
#       Refactor Base Configs & logging to .mk's 
#

cmake_minimum_required(VERSION 3.5.0)

# Include timestamp for logs
# Start Configuration Message
string(TIMESTAMP CURRENT_DATETIME "%Y-%m-%d %H:%M:%S")
message(STATUS "##########################################################################")
message(STATUS "## Starting to Configure the DemoIccMAX Project at ${CURRENT_DATETIME}")
message(STATUS "##########################################################################")

set(CMAKE_VERBOSE_MAKEFILE ON)
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configurations to build" FORCE)
    set_property(GLOBAL PROPERTY DEBUG_CONFIGURATIONS Debug)
    set_property(GLOBAL PROPERTY RELEASE_CONFIGURATIONS Release)
endif()

# Project Configuration
project(RefIccMAX)
set(PROJECT_UP_NAME "REFICCMAX")
message(STATUS "Set PROJECT_UP_NAME to '${PROJECT_UP_NAME}'.")
set(CMAKE_CXX_STANDARD 17)
message(STATUS "Set CMAKE_CXX_STANDARD to ${CMAKE_CXX_STANDARD}.")
set(${PROJECT_UP_NAME}_MAJOR_VERSION 2)
message(STATUS "${PROJECT_UP_NAME}_MAJOR_VERSION set to 2")
set(${PROJECT_UP_NAME}_MINOR_VERSION 1)
message(STATUS "${PROJECT_UP_NAME}_MINOR_VERSION set to 1")
set(${PROJECT_UP_NAME}_MICRO_VERSION 25)
message(STATUS "${PROJECT_UP_NAME}_MICRO_VERSION set to 25")
set(${PROJECT_UP_NAME}_VERSION
    "${${PROJECT_UP_NAME}_MAJOR_VERSION}.${${PROJECT_UP_NAME}_MINOR_VERSION}.${${PROJECT_UP_NAME}_MICRO_VERSION}"
)
message(STATUS "${PROJECT_UP_NAME}_VERSION set to ${${PROJECT_UP_NAME}_VERSION}")
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
    message(STATUS "macOS SDK Path: ${CMAKE_OSX_SYSROOT}")
    message(STATUS "Deployment Target: ${CMAKE_OSX_DEPLOYMENT_TARGET}")    
endif()

if(WIN32)
    message(STATUS "### Windows Specific Details ###")
    message(STATUS "Windows SDK Version: ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}")
    if(DEFINED ENV{MSBUILD_PATH})
        message(STATUS "MSBuild Path: $ENV{MSBUILD_PATH}")
    else()
        message(WARNING "MSBuild Path is not defined in environment variables.")
    endif()
    message(STATUS "Linker Flags: ${CMAKE_EXE_LINKER_FLAGS}")    
endif()

if(UNIX AND NOT APPLE)
    message(STATUS "### Linux/Unix Specific Details ###")
    execute_process(
        COMMAND uname -a
        OUTPUT_VARIABLE LINUX_SYSTEM_INFO
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message(STATUS "Linux System Info: ${LINUX_SYSTEM_INFO}")
    message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER}")
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
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "C++ Flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "C Flags: ${CMAKE_C_FLAGS}")
message(STATUS "Build Type & Flags (${CMAKE_BUILD_TYPE}): ${CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}}")

# Features Enabled/Disabled
message(STATUS "### Feature Configuration ###")
message(STATUS "Enable Tools: ${ENABLE_TOOLS}")
message(STATUS "Enable Tests: ${ENABLE_TESTS}")
message(STATUS "Enable Shared Libraries: ${ENABLE_SHARED_LIBS}")
message(STATUS "Enable Static Libraries: ${ENABLE_STATIC_LIBS}")

# Dependencies
message(STATUS "### Dependencies ###")
find_package(LibXml2 REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(TIFF REQUIRED)
message(STATUS "LibXml2: ${LIBXML2_LIBRARIES} (found version ${LIBXML2_VERSION})")
message(STATUS "nlohmann_json: ${nlohmann_json_DIR} (found version ${nlohmann_json_VERSION})")
message(STATUS "TIFF: ${TIFF_LIBRARIES} (found version ${TIFF_VERSION})")
message(STATUS "TIFF Include Directory: ${TIFF_INCLUDE_DIR}")

# Include Directories
message(STATUS "### Include Directories ###")
message(STATUS "IccProfLib: ${PROJECT_ROOT_DIR}/IccProfLib")
message(STATUS "IccXML: ${PROJECT_ROOT_DIR}/IccXML")

# Link Directories
message(STATUS "### Link Directories ###")
message(STATUS "IccProfLib: ${CMAKE_BINARY_DIR}/IccProfLib")
message(STATUS "IccXML: ${CMAKE_BINARY_DIR}/IccXML")
message(STATUS "/usr/local/lib")

# Library paths for debugging
message(STATUS "Library Path for IccProfLib: ${PROJECT_ROOT_DIR}/Build/IccProfLib")
message(STATUS "Library Path for IccXML: ${PROJECT_ROOT_DIR}/Build/IccXML")

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

message(STATUS "Starting GNUInstallDirs.")
include(GNUInstallDirs)

option(ENABLE_TESTS "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS "Build tools" ON)
option(ENABLE_SHARED_LIBS "Build dynamic link libs" ON)
option(ENABLE_STATIC_LIBS "Build static libs" ON)
option(ENABLE_ICCXML "Build IccXML library" ON)

IF(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
  OPTION(ENABLE_INSTALL_RIM "Install files" ON)
ELSE()
  MESSAGE( "-- RefIccMAX: compile as subproject - skip install (ENABLE_INSTALL_RIM=OFF)" )
  # disable install and build of shared libs for fallback subproject
  IF(NOT ENABLE_INSTALL_RIM)
    SET(ENABLE_INSTALL_RIM OFF)
  ENDIF(NOT ENABLE_INSTALL_RIM)
  SET(ENABLE_STATIC_LIBS ON)
  SET(ENABLE_SHARED_LIBS OFF)
ENDIF()

message(STATUS "Enforcing Build Type in ${CMAKE_CURRENT_SOURCE_DIR}")
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

message(STATUS "Setting Compiler Flags in ${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -fsanitize=address -fno-omit-frame-pointer -Wall -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")

# Architecture determination
if(APPLE)
  message(STATUS "Detected platform: macOS")
  execute_process(
    COMMAND uname -m
    COMMAND tr -d '\n'
    OUTPUT_VARIABLE OSX_ARCHITECTURE
  )
  if("${OSX_ARCHITECTURE}" STREQUAL "arm64")
    message(STATUS "Configuring build for ARM64 architecture.")
    set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "macOS architecture")
    add_compile_definitions(ARM64)
  elseif("${OSX_ARCHITECTURE}" STREQUAL "x86_64")
    message(STATUS "Configuring build for X86_64 architecture.")
    set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "macOS architecture")
  else()
    message(FATAL_ERROR "Unsupported macOS architecture: ${OSX_ARCHITECTURE}")
  endif()
  message(STATUS "Final macOS Architecture: ${CMAKE_OSX_ARCHITECTURES}")
elseif(UNIX AND NOT APPLE)
  message(STATUS "Detected platform: Linux")
  add_compile_options(-std=c++17 -Wall -Wextra -Wpedantic)
  message(STATUS "Linux build: Compiler flags set to C++17 with standard warnings.")
elseif(WIN32)
  message(STATUS "Detected platform: Windows")
  add_compile_options(/std:c++17 /D_WINDOWS /EHsc)
  message(STATUS "Windows build: Compiler flags set to C++17 with MSVC-specific flags.")
else()
  message(FATAL_ERROR "Unsupported platform!")
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
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccApplyToLink ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfile ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfileGui ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/ || echo ""
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromXML ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromCube ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccToXml ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccRoundTrip ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccSpecSepToTiff ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccTiffDump ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
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
