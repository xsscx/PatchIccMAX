# 
# IccXML2 Configuration CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 04-DEC-2024 by David Hoyt
#
#
#
#
#
#
#
#

message(STATUS "##########################################################################")
message(STATUS "## Entering the IccXML2 Project in Build/Cmake/IccXML/CMakelists.txt")

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
MESSAGE(STATUS "Project root resolved as ${PROJECT_ROOT_DIR}")
# Pretty-print the resolved C file paths
message(STATUS "Resolved C file paths:")
foreach(C_FILE IN LISTS CFILES)
    message(STATUS "  ${C_FILE}")
endforeach()

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

message(STATUS "## Exiting the IccXML2 Project in Build/Cmake/IccXML/CMakelists.txt")
message(STATUS "##########################################################################")
