# 
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
#
# Cmake Build System
# 
# Top Level Configuration | CMakeLists.txt | DemoIccMAX Project
#
# Changes: Troubleshoot legacy If/ELSE/THEN conditionals
#          Refactor of Source, Project and Cmake & Other Vars
#          Housekeeping
#						
# TODO: Refactor Debug, Release, Asan 
#       Collapse 3-tier CMakeLists.txt, Housekeeping, Refactor Base Configs & logging to .mk's 
# 
# Last Updated: 2024-11-26 by David Hoyt
#

cmake_minimum_required(VERSION 2.8.5)

if(POLICY CMP0079)
  cmake_policy(SET CMP0079 NEW)
endif()

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

# Include timestamp for logs
string(TIMESTAMP CURRENT_DATETIME "%Y-%m-%d %H:%M:%S")
message(STATUS "##########################################################################")
message(STATUS "## Starting Configuration for DemoIccMAX Project at ${CURRENT_DATETIME}")
message(STATUS "##########################################################################")

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

message(STATUS "##########################################################################")
message(STATUS "## Continuing the Configuration at ${CURRENT_DATETIME}")
message(STATUS "##########################################################################")

include(GNUInstallDirs)

option(ENABLE_TESTS "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS "Build tools" ON)
option(ENABLE_SHARED_LIBS "Build dynamic link libs" ON)
option(ENABLE_STATIC_LIBS "Build static libs" ON)
option(ENABLE_ICCXML "Build IccXML library" ON)

IF(EXISTS ${VCPKG_MANIFEST_DIR}/vcpkg.json)
  MESSAGE(STATUS "Detected vcpkg.json at: ${VCPKG_MANIFEST_DIR}/vcpkg.json")
ELSE()
  MESSAGE(WARNING "No vcpkg.json file found at: ${VCPKG_MANIFEST_DIR}/vcpkg.json. Ensure dependencies are manually resolved.")
ENDIF()

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

# Enforce build type to be Debug if not specified to ensure symbols are included
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

# Compiler flags for Debug and Release build types
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -fsanitize=address -fno-omit-frame-pointer -Wall -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")

# Architecture determination
if(APPLE)
  execute_process(
    COMMAND uname -m
    COMMAND tr -d '\n'
    OUTPUT_VARIABLE OSX_ARCHITECTURE
  )
  if("${OSX_ARCHITECTURE}" STREQUAL "arm64")
    add_definitions(-DARM64)
    message(STATUS "Configuring build for ARM64 architecture.")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch arm64")
  elseif("${OSX_ARCHITECTURE}" STREQUAL "x86_64")
    message(STATUS "Configuring build for X86_64 architecture.")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch x86_64")
  else()
    message(FATAL_ERROR "Unsupported architecture: ${OSX_ARCHITECTURE}")
  endif()
elseif(UNIX AND NOT APPLE)
  message(STATUS "Configuring build for Linux.")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++17")
elseif(WIN32)
  message(STATUS "Configuring build for Windows.")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /D_WINDOWS /EHsc")
else()
  message(FATAL_ERROR "Unsupported platform!")
endif()

# Debug configuration
if(CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]")
  message("-- Info: Debug build \"${CMAKE_BUILD_TYPE}\"")
  set(DEBUG 1)
  add_definitions(-D_DEBUG)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
endif()

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

# =====================================================================
# Core Library Configuration
# =====================================================================
add_subdirectory(IccProfLib)
set(TARGET_LIB_ICCPROFLIB ${TARGET_LIB})

# =====================================================================
# External Dependency: libxml2 (Optional, based on ENABLE_ICCXML flag)
# =====================================================================
if(ENABLE_ICCXML)
  message(STATUS "Configuring ICCXML support...")

  # Find libxml2 package dynamically (vcpkg or system-installed)
  find_package(LibXml2 REQUIRED CONFIG)

  if(LIBXML2_FOUND)
    message(STATUS "libxml2 found:")
    message(STATUS "  - Libraries: ${LIBXML2_LIBRARIES}")
    message(STATUS "  - Include Directory: ${LIBXML2_INCLUDE_DIR}")
    include_directories(${LIBXML2_INCLUDE_DIR})
    target_link_libraries(${TARGET_LIB_ICCPROFLIB} PRIVATE ${LIBXML2_LIBRARIES})
    set(HAVE_LIBXML2 1)
  else()
    message(FATAL_ERROR "libxml2 is required but was not found. Ensure it is installed and discoverable.")
  endif()

  # Debugging: Log additional library path information
  if(NOT LIBXML2_FOUND)
    message(WARNING "libxml2 not found. Attempting manual path checks...")
    file(GLOB LIBXML2_PATHS "${CMAKE_SOURCE_DIR}/vcpkg_installed/x64-windows/lib/*")
    foreach(PATH ${LIBXML2_PATHS})
      message(STATUS "Detected libxml2 path: ${PATH}")
    endforeach()
  endif()

  # Add the IccXML library
  add_subdirectory(IccXML)
  set(TARGET_LIB_ICCXML ${TARGET_LIB})
  include_directories(${TOP_SOURCE_DIR}/IccXML/IccLibXML/)

else()
  message(STATUS "ICCXML support is disabled.")
endif()

# =====================================================================
# Debug Information for Build Configuration
# =====================================================================
message(STATUS "Build Configuration Summary:")
message(STATUS "  - ICC ProfLib: ${TARGET_LIB_ICCPROFLIB}")
if(ENABLE_ICCXML)
  message(STATUS "  - ICCXML Enabled: ${ENABLE_ICCXML}")
  if(HAVE_LIBXML2)
    message(STATUS "  - libxml2 Support: Enabled")
  else()
    message(STATUS "  - libxml2 Support: Disabled")
  endif()
else()
  message(STATUS "  - ICCXML Support: Disabled")
endif()

# =====================================================================
# Add nlohmann_json-dependent Tools
# =====================================================================
find_package(nlohmann_json REQUIRED)
message(STATUS "nlohmann_json library found: ${nlohmann_json_DIR}")

# =====================================================================
# ENABLE_TOOLS Handling
# =====================================================================

if(ENABLE_TOOLS)
  # Verify nlohmann_json is configured properly
  if(nlohmann_json_DIR)
    message(STATUS "Found nlohmann JSON library at: ${nlohmann_json_DIR}")
    include_directories(${nlohmann_json_DIR})

message(STATUS "Adding IccApplyNamedCmm from: ${ICC_APPLY_NAMED_CMM_PATH}")

# =====================================================================
# Ensure IccApplyNamedCmm is added in nlohmann_json-dependent Tools
# =====================================================================
set(ICC_APPLY_NAMED_CMM_PATH "${CMAKE_SOURCE_DIR}/Tools/IccApplyNamedCmm")

# Add IccApplyNamedCmm
message(STATUS "Checking IccApplyNamedCmm at: ${ICC_APPLY_NAMED_CMM_PATH}")
if(EXISTS ${ICC_APPLY_NAMED_CMM_PATH})
  message(STATUS "Adding IccApplyNamedCmm from: ${ICC_APPLY_NAMED_CMM_PATH}")
  add_subdirectory(
    ${ICC_APPLY_NAMED_CMM_PATH}
    ${CMAKE_BINARY_DIR}/Tools/IccApplyNamedCmm_Build
  )
  message(STATUS "Successfully added IccApplyNamedCmm")
else()
  # Handle Directory Errors for IccApplyNamedCmm
  message(FATAL_ERROR "Directory does not exist: ${ICC_APPLY_NAMED_CMM_PATH}")
endif()


# =====================================================================
# Ensure IccApplyProfiles is added in nlohmann_json-dependent Tools
# =====================================================================
set(ICC_APPLY_NAMED_CMM_PATH "${CMAKE_SOURCE_DIR}/Tools/IccApplyProfiles")

# Add IccApplyProfiles
message(STATUS "Checking IccApplyProfiles at: ${ICC_APPLY_PROFILE_PATH}")
if(EXISTS ${ICC_APPLY_NAMED_CMM_PATH})
  message(STATUS "Adding IccApplyProfiles from: ${ICC_APPLY_PROFILE_PATH}")
  add_subdirectory(
    ${ICC_APPLY_NAMED_CMM_PATH}
    ${CMAKE_BINARY_DIR}/Tools/IccApplyProfiles_Build
  )
  message(STATUS "Successfully added IccApplyProfiles")
else()
  # Handle Directory Errors for IccApplyProfiles
  message(FATAL_ERROR "Directory does not exist: ${ICC_APPLY_PROFILES_PATH}")
endif()


# =====================================================================
# Handle nlohmann JSON library not found
# =====================================================================

  else() # nlohmann_json_DIR is not set
    message(WARNING "nlohmann JSON library not found. Skipping Tools/IccApplyNamedCmm and Tools/IccApplyProfiles.")
    return() # Exit script for tools if dependency is not found
  endif()

# =====================================================================
# Add Remaining Tools
# =====================================================================

  add_subdirectory(Tools/IccDumpProfile)
  add_subdirectory(Tools/IccRoundTrip)

# =====================================================================
# Ensure tiff is found
# =====================================================================

  find_package(TIFF REQUIRED)
  if(TIFF_FOUND)
    include_directories(${TIFF_INCLUDE_DIR})
    message(STATUS "TIFF library found: ${TIFF_LIBRARIES}")

# =====================================================================
# Add TIFF-dependent Tools
# =====================================================================

    message(STATUS "Adding IccSpecSepToTiff from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccSpecSepToTiff")
    add_subdirectory(Tools/IccSpecSepToTiff)
    message(STATUS "Adding IccSpecSepToTiff from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccTiffDump")
    add_subdirectory(Tools/IccTiffDump)
  else()
  
# =====================================================================
# Handle TIFF Dependency Not Found Errors
# =====================================================================

    message(FATAL_ERROR "TIFF library not found. Please install libtiff-dev.")
  endif()

# =====================================================================
# Add XML-dependent Tools
# =====================================================================

  add_subdirectory(Tools/IccFromXml)
  add_subdirectory(Tools/IccToXml)

# =====================================================================
# Add wxWidgets
# =====================================================================
  # Configure wxWidgets
  find_package(wxWidgets COMPONENTS core base REQUIRED)
  if(wxWidgets_FOUND)
    include(${wxWidgets_USE_FILE})
    message(STATUS "wxWidgets found and configured")
  else()
    message(FATAL_ERROR "wxWidgets not found. Please install it manually or via vcpkg.")
  endif()

else() # ENABLE_TOOLS is OFF
  message(STATUS "ENABLE_TOOLS is OFF. Skipping tools configuration.")
endif()


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
