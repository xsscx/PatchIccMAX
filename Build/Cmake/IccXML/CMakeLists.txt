##################################################################################
## IccXML Project Configuration in Build/Cmake/IccXML/CMakeLists.txt            ##
##################################################################################
# 
# IccXML Project Configuration CMakeLists.txt | IccMAX Project
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
# 
#
# Last Updated: 18-MAR-2025 093* EDT by David Hoyt
#
# Changes:  Lower Noise Level
#           Fixups for Iconv and Headers
#           PASS: Generators, Code Analysis & Insight, x64-MinSizeRel & x64-Debug
#						
# TODO: Refactor Debug, Release, Asan 
#       Housekeeping, Unix & Windows now Build from Cmake
#       Refactor Base Configs & logging to .mk's 
##################################################################################
## IccXML Project Configuration in Build/Cmake/IccXML/CMakeLists.txt            ##
##################################################################################

SET(TARGET_NAME IccXML2)

# Set source paths and files
SET(SRC_PATH ../../..)
SET(CFILES
    ${SRC_PATH}/IccXML/IccLibXML/IccIoXml.cpp
    ${SRC_PATH}/IccXML/IccLibXML/IccMpeXml.cpp
    ${SRC_PATH}/IccXML/IccLibXML/IccMpeXmlFactory.cpp
    ${SRC_PATH}/IccXML/IccLibXML/IccProfileXml.cpp
    ${SRC_PATH}/IccXML/IccLibXML/IccTagXml.cpp
    ${SRC_PATH}/IccXML/IccLibXML/IccTagXmlFactory.cpp
    ${SRC_PATH}/IccXML/IccLibXML/IccUtilXml.cpp
)

# Include directories
SET(INCLUDE_DIRS
    ${SRC_PATH}/IccProfLib
    ${SRC_PATH}/IccXML/IccLibXML
    C:/test/vcpkg/installed/x64-windows/include
)
INCLUDE_DIRECTORIES(${INCLUDE_DIRS})

# Enable symbol exports on Windows
if (WIN32)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

# Add the shared library
ADD_LIBRARY(${TARGET_NAME} SHARED ${CFILES})
SET_TARGET_PROPERTIES(${TARGET_NAME}
    PROPERTIES
    VERSION ${${PROJECT_UP_NAME}_VERSION}
    SOVERSION ${${PROJECT_UP_NAME}_MAJOR_VERSION}
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/Release
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/Release
    LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/Release
)

# Ensure the target is defined before adding include directories
target_include_directories(${TARGET_NAME} PRIVATE
    "$ENV{VCPKG_ROOT}/installed/x64-windows/include"
    "$ENV{VCPKG_ROOT}/installed/x64-windows/include/libxml2"
    "$ENV{VCPKG_ROOT}/installed/x64-windows/include/libxml"
)

    message(STATUS "[DEBUG] Shared Library Output Properties:")
    message(STATUS "  RUNTIME: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    message(STATUS "  LIBRARY: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
    message(STATUS "  ARCHIVE: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")

find_library(LIBICONV_LIBRARY NAMES iconv libiconv PATHS "${VCPKG_ROOT}/installed/x64-windows/lib")
find_path(LIBICONV_INCLUDE_DIR NAMES iconv.h PATHS "${VCPKG_ROOT}/installed/x64-windows/include")

if (LIBICONV_LIBRARY AND LIBICONV_INCLUDE_DIR)
    message(STATUS "Found libiconv: ${LIBICONV_LIBRARY}, includes at ${LIBICONV_INCLUDE_DIR}")
else()
    message(FATAL_ERROR "libiconv not found! Ensure vcpkg is installed correctly.")
endif() 

# Generate .def file for symbol exports if necessary
if (WIN32)
    target_link_options(${TARGET_NAME} PRIVATE
        /DEF:"${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.def"
    )
endif()

# Link against required libraries
TARGET_LINK_LIBRARIES(${TARGET_NAME} PRIVATE
    ${TARGET_LIB_ICCPROFLIB}
    ${LIBXML2_LIBRARIES}
)

# Installation rules
IF(ENABLE_INSTALL_RIM)
    INSTALL(TARGETS ${TARGET_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
ENDIF()

# Debugging Information
# MESSAGE(STATUS "Project root resolved as ${PROJECT_ROOT_DIR}")
# Pretty-print the resolved C file paths
# message(STATUS "Resolved C file paths:")
# foreach(C_FILE IN LISTS CFILES)
#     message(STATUS "  ${C_FILE}")
# endforeach()

MESSAGE(STATUS "Include directories:")
FOREACH(DIR ${INCLUDE_DIRS})
    MESSAGE(STATUS "  - ${DIR}")
ENDFOREACH()
# Pretty-print the resolved libraries for linking
message(STATUS "Linking against libraries:")
foreach(LIBRARY IN LISTS LIBXML2_LIBRARIES)
    message(STATUS "  ${LIBRARY}")
endforeach()

MESSAGE(STATUS "Added shared library target: ${TARGET_NAME}")

# Export library name for linking in other projects
SET(TARGET_LIB ${TARGET_NAME} PARENT_SCOPE)

# Project root directory
message(STATUS "Resolved Project Root Directory:")
message(STATUS "  ${PROJECT_ROOT_DIR}")

# CMake source directory
message(STATUS "Resolved CMake Source Directory:")
message(STATUS "  ${CMAKE_SOURCE_DIR}")

# Source path
message(STATUS "Resolved Source Path:")
message(STATUS "  ${SRC_PATH}")

# Target name
message(STATUS "Added Target:")
message(STATUS "  ${TARGET_NAME}")

# Extra libraries
message(STATUS "Using Extra Libraries:")
if(EXTRA_LIBS)
    foreach(LIBRARY IN LISTS EXTRA_LIBS)
        message(STATUS "  ${LIBRARY}")
    endforeach()
else()
    message(STATUS "  No extra libraries specified.")
endif()

# .def file for symbol exports
message(STATUS "Using .def File for Symbol Exports:")
if(DEF_FILE)
    message(STATUS "  ${DEF_FILE}")
else()
    message(STATUS "  No .def file specified.")
endif()

message(STATUS "")
