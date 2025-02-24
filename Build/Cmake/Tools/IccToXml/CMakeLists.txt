#########################################################################################
#
# IccToXml in Project_Root/Build/Cmake/Tools/IccToXml/CMakeLists.txt | IccMAX Project
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Last Updated: 17-MAR-2025 0955 EDT by David Hoyt
#
# Changes: Modified Cmake Configuration at top and project level
#          Aligned target named to 'i' lowercase
#         
#
#
# TODO: Configure proper verbose flags for cmake config
#
#
#
#
#
#########################################################################################

# Resolve project root directory
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")

# Define source path and file
set(SRC_PATH "${PROJECT_ROOT_DIR}/IccXML/CmdLine/IccToXml")
set(SOURCES "${SRC_PATH}/IccToXml.cpp")
if (NOT EXISTS "${SOURCES}")
    message(FATAL_ERROR "DEBUG: Source file not found at: ${SOURCES}. Verify the file exists.")
endif()
message(STATUS "Source file resolved as: ${SOURCES}")

# Add executable target
set(TARGET_NAME "iccToXml")
add_executable(${TARGET_NAME} ${SOURCES})
message(STATUS "Added executable target: ${TARGET_NAME}")

# Add include directories
target_include_directories(${TARGET_NAME} PRIVATE
    "${PROJECT_ROOT_DIR}/IccProfLib"
    "${PROJECT_ROOT_DIR}/IccXML/IccLibXml"
)
message(STATUS "Include directories added for ${TARGET_NAME}")

# Add linker directories
target_link_directories(${TARGET_NAME} PRIVATE
    "${ICCPROFLIB_DIR}"
    "${IccXML_LIB_DIR}"
    "${LIBXML2_DIR}"
)
message(STATUS "Linker directories added for ${TARGET_NAME}")

# Link required libraries
target_link_libraries(${TARGET_NAME} PRIVATE
    IccProfLib2
    IccXML2
    ${TARGET_LIB_ICCXML} )
message(STATUS "Libraries linked for ${TARGET_NAME}")

# Set output directories
set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_ROOT_DIR}/Testing/Release"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_ROOT_DIR}/Testing/Debug"
)
message(STATUS "Output directories set for ${TARGET_NAME}")
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "CMAKE_SOURCE_DIR resolved as: ${CMAKE_SOURCE_DIR}")
message(STATUS "SRC_PATH resolved as: ${SRC_PATH}")
message(STATUS "Resolved source file path: ${SOURCES}")
message(STATUS "Added executable target: ${TARGET_NAME}")
message(STATUS "Added linker options for library path.")
message(STATUS "Using explicit absolute path for ICCPROFLIB_PATH: ${ICCPROFLIB_PATH}")
message(STATUS "")
