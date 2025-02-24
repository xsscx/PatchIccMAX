############################################################################## 
## Top Level IccMAX Project Configuration in Build/Cmake/CMakeLists.txt ##
##############################################################################
## 
##          Copyright (©) 2024-2025 David H Hoyt LLC | All rights reserved.
## 
## Last Updated: 14-MAR-2025 at 1031 EDT by David Hoyt (©)
##
## Changes:  Refactored Build/Cmake/DemoIccMAXCmm/CmakeLists.txt
##           Added to conditions, require dep
##           Cmake Builds Tested on Win, Unix, macOS x64 | MinRelSize + Debug
##						
## TODO: Refactor Debug, Release, Asan 
##       Collapse 3-tier CMakeLists.txt, Housekeeping
##       Refactor Base Configs & logging to .mk's 
##
##############################################################################
## Top Level IccMAX Project Configuration in Build/Cmake/CMakeLists.txt ##
##############################################################################

cmake_minimum_required(VERSION 3.5.0)

# Include timestamp for logs
# Start Configuration Message
string(TIMESTAMP CURRENT_DATETIME "%Y-%m-%d %H:%M:%S")
message(STATUS "##########################################################################")
message(STATUS "## Starting config in Build/Cmake/CMakeLists.txt at ${CURRENT_DATETIME}")
message(STATUS "")

# Verbose makefiles for debugging
set(CMAKE_VERBOSE_MAKEFILE ON)

macro(pretty_debug MESSAGE_TITLE MESSAGE_VALUE)
    message(STATUS "##########################################################################")
    message(STATUS "### ${MESSAGE_TITLE}")
    message(STATUS "### Value: ${MESSAGE_VALUE}")
    message(STATUS "##########################################################################")
endmacro()

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
"${${PROJECT_UP_NAME}_MAJOR_VERSION}.${${PROJECT_UP_NAME}_MINOR_VERSION}.${${PROJECT_UP_NAME}_MICRO_VERSION}")
message(STATUS "${PROJECT_UP_NAME}_VERSION PROJECT_UP_NAME set to ${${PROJECT_UP_NAME}_VERSION}")

set(PROJECT_DOWN_NAME "reficcmax")
set(PACKAGE_NAME "${PROJECT_DOWN_NAME}")
message(STATUS "${PROJECT_DOWN_NAME} PROJECT_DOWN_NAME Version set to ${${PROJECT_UP_NAME}_VERSION}")

set(PACKAGE_DESCRIPTION "The RefIccMAX project provides an open source set of libraries and tools that allow for the interaction, manipulation, and application of iccMAX-based color management profiles based on the iccMAX specification http://www.color.org/iccmax.xalter, in addition to legacy ICC profiles defined by earlier ICC specifications.")
set(${PROJECT_NAME}_VERSION_MAJORMINOR "${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}")

# Configure Build Types
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configurations to build" FORCE)
endif()
message(STATUS "Build Configurations: ${CMAKE_CONFIGURATION_TYPES}")

# Define the true project root directory
set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR}/../..)
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "")

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
message(STATUS "")

# Debugging and Host System Details
message(STATUS "### System Information ###")
message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
message(STATUS "PROJECT_ROOT_DIR is resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "System Name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "System Version: ${CMAKE_SYSTEM_VERSION}")
message(STATUS "System Processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Build Host: $ENV{COMPUTERNAME} ($ENV{USERNAME})")

message(STATUS "")
# Environment Debugging
message(STATUS "### Environment Details ###")
if(WIN32)
    set(PATH_SEPARATOR ";")
else()
    set(PATH_SEPARATOR ":")
endif()
string(REPLACE "${PATH_SEPARATOR}" ";" PATH_LIST "$ENV{PATH}")
list(LENGTH PATH_LIST PATH_LENGTH)
message(STATUS "Path Separator: ${CMAKE_PATH_SEPARATOR}")
message(STATUS "PATH Environment Variable (${PATH_LENGTH} entries):")
foreach(INDEX RANGE 0 [expr ${PATH_LENGTH} - 1])
    list(GET PATH_LIST ${INDEX} PATH_ENTRY)
    message(STATUS "[${INDEX}] ${PATH_ENTRY}")
endforeach()

# Split the PATH variable into a list
string(REPLACE "${PATH_SEPARATOR}" ";" PATH_LIST "$ENV{PATH}")
list(LENGTH PATH_LIST PATH_LENGTH)

# Generate numbered output
message(STATUS "### PATH Environment Variable ###")
foreach(INDEX RANGE 0 [expr ${PATH_LENGTH} - 1])
    list(GET PATH_LIST ${INDEX} PATH_ENTRY)
    message(STATUS "[${INDEX}] ${PATH_ENTRY}")
endforeach()
message(STATUS "")
message(STATUS "### CMAKE_ Details ###")
message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")
message(STATUS "")
message(STATUS "### Compiler Information ###")
message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ Compiler ID: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "C++ Compiler Version: ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C Compiler Version: ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "Linker: ${CMAKE_LINKER}")
message(STATUS "")

# Logging Configuration
message(STATUS "## Logging Config ##")
set(LOGGING_ENABLED ON CACHE BOOL "Enable or disable logging")
if(LOGGING_ENABLED)
    add_definitions(-DLOGGING_ENABLED=1)
    message(STATUS "Logging is enabled")
else()
    add_definitions(-DLOGGING_ENABLED=0)
    message(STATUS "Logging is disabled")
endif()
message(STATUS "")

# Additional Debug Logging
message(STATUS "## Logging Debug Config ##")
set(DEBUG_LOGGING ON CACHE BOOL "Enable or disable additional debug logging")
if(DEBUG_LOGGING)
    add_definitions(-DDEBUG_LOGGING=1)
    message(STATUS "Debug logging is enabled")
else()
    add_definitions(-DDEBUG_LOGGING=0)
    message(STATUS "Debug logging is disabled")
endif()
message(STATUS "")
message(STATUS "## Platform-Specific Flags ##")
# Platform-Specific Details
if(APPLE)
    message(STATUS "### macOS Specific Details ###")
    message(STATUS "macOS SDK Path: ${CMAKE_OSX_SYSROOT}")
    message(STATUS "Deployment Target: ${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()

if(WIN32)
    message(STATUS "### Windows Specific Details ###")
    message(STATUS "Windows SDK Version: ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}")

    # Check if MSBuild is available in the PATH
    find_program(MSBUILD_EXECUTABLE NAMES msbuild)
    if(MSBUILD_EXECUTABLE)
        message(STATUS "MSBuild found at: ${MSBUILD_EXECUTABLE}")
    else()
        message(WARNING "MSBuild not found in PATH. Please verify your Visual Studio installation.")
    endif()

    # Vcpkg toolchain configuration
    set(CMAKE_TOOLCHAIN_FILE "C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE STRING "Vcpkg toolchain file")
    if(EXISTS ${CMAKE_TOOLCHAIN_FILE})
        message(STATUS "Using Vcpkg toolchain file: ${CMAKE_TOOLCHAIN_FILE}")
    else()
        message(WARNING "Vcpkg toolchain file not found. Please verify your Vcpkg installation.")
    endif()
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
message(STATUS "")

# Cross-Platform Debugging
message(STATUS "### Cross-Platform Debugging Details ###")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "Build Generator: ${CMAKE_GENERATOR}")
message(STATUS "Build Tool: ${CMAKE_MAKE_PROGRAM}")
message(STATUS "")

# Build Configuration
message(STATUS "### Build Configuration ###")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "C++ Flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "C Flags: ${CMAKE_C_FLAGS}")
message(STATUS "Build Type & Flags (${CMAKE_BUILD_TYPE}): ${CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}}")
message(STATUS "")

# Feature Configuration
message(STATUS "### Feature Configuration ###")
option(ENABLE_TOOLS "Enable tool building" OFF)
option(ENABLE_TESTS "Enable testing" OFF)
option(ENABLE_SHARED_LIBS "Build shared libraries" ON)
option(ENABLE_STATIC_LIBS "Build static libraries" OFF)
message(STATUS "Enable Tools: ${ENABLE_TOOLS}")
message(STATUS "Enable Tests: ${ENABLE_TESTS}")
message(STATUS "Enable Shared Libraries: ${ENABLE_SHARED_LIBS}")
message(STATUS "Enable Static Libraries: ${ENABLE_STATIC_LIBS}")
message(STATUS "")

# Build Configuration
message(STATUS "### Build Configuration ###")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "C++ Flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "C Flags: ${CMAKE_C_FLAGS}")
message(STATUS "Build Type & Flags (${CMAKE_BUILD_TYPE}): ${CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}}")
message(STATUS "")

# Features Enabled/Disabled
message(STATUS "### Feature Configuration ###")
message(STATUS "Enable Tools: ${ENABLE_TOOLS}")
message(STATUS "Enable Tests: ${ENABLE_TESTS}")
message(STATUS "Enable Shared Libraries: ${ENABLE_SHARED_LIBS}")
message(STATUS "Enable Static Libraries: ${ENABLE_STATIC_LIBS}")
message(STATUS "")

# Dependencies
message(STATUS "### Dependencies ###")

# Function to log dependency information
function(log_dependency DEP_NAME LIBRARIES INCLUDE_DIR VERSION)
    message(STATUS "Checking for ${DEP_NAME}...")
    if(${DEP_NAME}_FOUND)
        message(STATUS "  ${DEP_NAME} Library: ${LIBRARIES}")
        message(STATUS "  ${DEP_NAME} Include Directory: ${INCLUDE_DIR}")
        message(STATUS "  ${DEP_NAME} Version: ${VERSION}")
    else()
        message(FATAL_ERROR "${DEP_NAME} not found. Please install it.")
    endif()
endfunction()

# Find and log LibXml2
find_package(LibXml2 REQUIRED)
log_dependency("LibXml2" "${LIBXML2_LIBRARIES}" "${LIBXML2_INCLUDE_DIR}" "${LIBXML2_VERSION}")
message(STATUS "")
execute_process(COMMAND xml2-config --version
                OUTPUT_VARIABLE LIBXML2_VERSION
                OUTPUT_STRIP_TRAILING_WHITESPACE)

# Find and log nlohmann_json
message(STATUS "Checking for nlohmann_json...")
find_package(nlohmann_json REQUIRED)
if(nlohmann_json_FOUND)
    message(STATUS "  nlohmann_json Directory: ${nlohmann_json_DIR}")
    message(STATUS "  nlohmann_json Version: ${nlohmann_json_VERSION}")
else()
    message(FATAL_ERROR "nlohmann_json not found. Please install it.")
endif()
message(STATUS "")

# Find and log TIFF
message(STATUS "Checking for TIFF...")
find_package(TIFF REQUIRED)
if(TIFF_FOUND)
    message(STATUS "  TIFF Library: ${TIFF_LIBRARIES}")
    message(STATUS "  TIFF Include Directory: ${TIFF_INCLUDE_DIR}")
    message(STATUS "  TIFF Version: ${TIFF_VERSION}")
else()
    message(FATAL_ERROR "TIFF not found. Please install libtiff-dev.")
endif()
message(STATUS "")

find_package(PNG REQUIRED)
message(STATUS "PNG: ${PNG_LIBRARIES} (found version ${PNG_VERSION})")
message(STATUS "PNG Include Directory: ${PNG_INCLUDE_DIRS}")

# Include Directories Section
message(STATUS "### Include Directories ###")
message(STATUS "  IccProfLib: ${PROJECT_ROOT_DIR}/IccProfLib")
message(STATUS "  IccXML: ${PROJECT_ROOT_DIR}/IccXML")
message(STATUS "")

# Link Directories Section
message(STATUS "### Link Directories ###")
message(STATUS "  IccProfLib: ${CMAKE_BINARY_DIR}/IccProfLib")
message(STATUS "  IccXML: ${CMAKE_BINARY_DIR}/IccXML")
message(STATUS "  /usr/local/lib")
message(STATUS "")

# Library Paths Section
message(STATUS "### Library Paths ###")
message(STATUS "  Library Path for IccProfLib: ${PROJECT_ROOT_DIR}/Build/IccProfLib")
message(STATUS "  Library Path for IccXML: ${PROJECT_ROOT_DIR}/Build/IccXML")
message(STATUS "")

message(STATUS "## Starting GNUInstallDirs ##")
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

message(STATUS "")
message(STATUS "Enforcing Build Type ")
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

message(STATUS "")
message(STATUS "Setting Compiler Flags ")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -fsanitize=address -fno-omit-frame-pointer -Wall -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")

# Platform-Specific Details
if(APPLE)
    message(STATUS "### macOS Specific Details ###")
    message(STATUS "macOS SDK Path: ${CMAKE_OSX_SYSROOT}")
    message(STATUS "Deployment Target: ${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()

if(WIN32)
    message(STATUS "### Windows Specific Details ###")
    message(STATUS "Windows SDK Version: ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}")

    # Safely retrieve the ProgramFiles(x86) environment variable
    execute_process(
        COMMAND cmd /c "echo %ProgramFiles(x86)%"
        OUTPUT_VARIABLE PROGRAMFILES_X86
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(PROGRAMFILES_X86 AND NOT PROGRAMFILES_X86 MATCHES "^$")
        message(STATUS "ProgramFiles(x86): ${PROGRAMFILES_X86}")
    else()
        message(WARNING "ProgramFiles(x86) is not defined or could not be retrieved.")
        set(PROGRAMFILES_X86 "")
    endif()

    # Define potential MSBuild paths
    set(MSBUILD_PATHS
        "${PROGRAMFILES_X86}/Microsoft Visual Studio/2022/Enterprise/MSBuild/Current/Bin"
        "${PROGRAMFILES_X86}/Microsoft Visual Studio/2022/Professional/MSBuild/Current/Bin"
        "${PROGRAMFILES_X86}/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin"
    )

    # Find MSBuild
    find_program(MSBUILD_EXECUTABLE NAMES MSBuild PATHS ${MSBUILD_PATHS} NO_DEFAULT_PATH)
    if(MSBUILD_EXECUTABLE)
        message(STATUS "MSBuild found at: ${MSBUILD_EXECUTABLE}")
    else()
        message(WARNING "MSBuild not found. Please verify your Visual Studio installation.")
    endif()
endif()

# Platform-Specific Flags
if(MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MDd /Zi /Ob0 /Od /RTC1")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MD /O2 /Ob2 /DNDEBUG")
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
    message(STATUS "Configuring MSVC runtime and flags")
elseif(UNIX)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -Wall -Wextra -DDEBUG")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -DNDEBUG")
    message(STATUS "Configuring GCC/Clang runtime and flags")
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

message(STATUS "LibXml2 Library: ${LIBXML2_LIBRARY}")
message(STATUS "LibXml2 Include Directory: ${LIBXML2_INCLUDE_DIR}")

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

 # Function to add and log subdirectories
function(add_tool_subdirectory TOOL_SUBDIRECTORY)
    message(STATUS "Adding Subdirectory: ${TOOL_SUBDIRECTORY}...")
    add_subdirectory(${TOOL_SUBDIRECTORY})
    message(STATUS "Successfully added Subdirectory: ${TOOL_SUBDIRECTORY}")
endfunction()

# Function to log TIFF library information
function(log_tiff_library LIBRARIES INCLUDE_DIR)
    if(LIBRARIES AND INCLUDE_DIR)
        message(STATUS "TIFF library found:")
        message(STATUS "  TIFF Library: ${LIBRARIES}")
        message(STATUS "  TIFF Include Directory: ${INCLUDE_DIR}")
    else()
        message(FATAL_ERROR "TIFF library variables are not correctly set.")
    endif()
endfunction()

# Add remaining tools
add_tool_subdirectory("Tools/IccDumpProfile")
add_tool_subdirectory("Tools/IccRoundTrip")
add_tool_subdirectory("Tools/IccFromCube")
add_tool_subdirectory("Tools/IccV5DspObsToV4Dsp")
add_tool_subdirectory("Tools/IccApplyToLink")

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

# Check for TIFF library with logging
message(STATUS "Checking for TIFF library...")
find_package(TIFF REQUIRED)

if(TIFF_FOUND)
    log_tiff_library("${TIFF_LIBRARIES}" "${TIFF_INCLUDE_DIR}")
    
    # Include the TIFF library directories
    include_directories(${TIFF_INCLUDE_DIR})

    # Add TIFF-dependent tools
    add_tool_subdirectory("Tools/IccSpecSepToTiff")
    add_tool_subdirectory("Tools/IccTiffDump")
else()
    message(FATAL_ERROR "TIFF library not found. Please install libtiff-dev.")
endif()

# Additional logging for other libraries or configurations
if(TIFF_LIBRARIES AND TIFF_INCLUDE_DIR)
    message(STATUS "TIFF Library: ${TIFF_LIBRARIES}")
    message(STATUS "TIFF Include Directory: ${TIFF_INCLUDE_DIR}")
else()
    message(WARNING "TIFF library variables are not set despite finding the library.")
endif()

if(DEFINED nlohmann_json_DIR)
    message(STATUS "nlohmann_json Directory: ${nlohmann_json_DIR}")
else()
    message(WARNING "nlohmann_json Directory variable is not set.")
endif()


# Additional logging for other libraries or configurations
message(STATUS "TIFF Library: ${TIFF_LIBRARIES}")
message(STATUS "TIFF Include Directory: ${TIFF_INCLUDE_DIR}")
message(STATUS "nlohmann_json Directory: ${nlohmann_json_DIR}")

# Define project-specific subdirectory
set(PROJECT_TOOL_SUBDIRECTORY "Tools/IccFromXml")

# Log and add the subdirectory
message(STATUS "Adding subdirectory: ${PROJECT_TOOL_SUBDIRECTORY}...")
add_subdirectory(${PROJECT_TOOL_SUBDIRECTORY})
message(STATUS "Successfully added subdirectory: ${PROJECT_TOOL_SUBDIRECTORY}")

# Define project-specific subdirectory
set(PROJECT_SUBDIRECTORY "Tools/IccToXml")

# Log and add the subdirectory
message(STATUS "Configuring ${PROJECT_SUBDIRECTORY}...")
add_subdirectory(${PROJECT_SUBDIRECTORY})
message(STATUS "Successfully added subdirectory: ${PROJECT_SUBDIRECTORY}")

# Define project-specific subdirectory
set(PROJECT_SUBDIRECTORY "Tools/DemoIccMAXCmm")

# Log and add the subdirectory
message(STATUS "Configuring ${PROJECT_SUBDIRECTORY}...")
add_subdirectory(${PROJECT_SUBDIRECTORY})
add_dependencies(DemoIccMAXCmm IccProfLib2-static)
message(STATUS "Successfully added subdirectory: ${PROJECT_SUBDIRECTORY}")

# Configure wxWidgets with detailed logging
message(STATUS "### Configuring wxWidgets ###")

find_package(wxWidgets COMPONENTS core base REQUIRED)

if(wxWidgets_FOUND)
    message(STATUS "wxWidgets successfully found and configured:")
    message(STATUS "  Include Directories:")
    foreach(INCLUDE_DIR IN LISTS wxWidgets_INCLUDE_DIRS)
        message(STATUS "    ${INCLUDE_DIR}")
    endforeach()
    message(STATUS "  Libraries:")
    foreach(LIBRARY IN LISTS wxWidgets_LIBRARIES)
        message(STATUS "    ${LIBRARY}")
    endforeach()
    include(${wxWidgets_USE_FILE})
    message(STATUS "wxWidgets configuration completed successfully.")
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

message(STATUS "--------------------------------------------------------------------------")
message(STATUS "## Exiting config in Build/Cmake/CMakeLists.txt at ${CURRENT_DATETIME}")
message(STATUS "--------------------------------------------------------------------------")
