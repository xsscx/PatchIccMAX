############################################################################## 
#
# IccApplyToLink in Project_Root/Build/Cmake/Tools/IccApplyToLink/CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Last Updated: 17-MAR-2025 1012 EDT by David Hoyt
#
# Changes: Modified Build/Cmake/CMakelists.txt
#          Added explicit linker paths, Reduced Noise
#          Improved debug output for cross-platform support
#
#
#
#
#
#
#
#
#
############################################################################## 

# Define the project
project(iccApplyToLink)

# Define target name
set(TARGET_NAME "iccApplyToLink")

# Determine project root and source paths
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "CMAKE_SOURCE_DIR resolved as: ${CMAKE_SOURCE_DIR}")

# Avoid redefining the target if it already exists
if (TARGET ${TARGET_NAME})
    message(WARNING "Target '${TARGET_NAME}' is already defined. Skipping target creation.")
    return()
endif()

message(STATUS "Defining target '${TARGET_NAME}'...")

# Define source path and file
set(SRC_PATH "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyToLink")
set(SOURCES "${SRC_PATH}/iccApplyToLink.cpp")
message(STATUS "Resolved source file path: ${SOURCES}")

# Verify the source file exists
if (NOT EXISTS "${SOURCES}")
    message(FATAL_ERROR "Source file not found: ${SOURCES}. Verify the file exists and the path is correct.")
endif()

# Add the executable target
add_executable(${TARGET_NAME} ${SOURCES})
message(STATUS "Added executable target: ${TARGET_NAME}")

# Include directories
target_include_directories(${TARGET_NAME} PRIVATE
    "${PROJECT_ROOT_DIR}/IccProfLib"
)

# Platform-specific configurations
if (WIN32)
    # Compiler options for Windows
    target_compile_options(${TARGET_NAME} PRIVATE
        /MP /GS /W3 /wd4996 /Gy /Zc:wchar_t /Zc:inline
        /fp:precise /DWIN32 /D"_VC80_UPGRADE=0x0710"
        /D"_MBCS" /GF /MT /FC /diagnostics:column
        $<$<CONFIG:Release>:/O2 /Ob1 /GL /Oi>
        $<$<CONFIG:Debug>:/Od>
    )
    # Linker options for Windows
    target_link_options(${TARGET_NAME} PRIVATE
        /SUBSYSTEM:CONSOLE /DYNAMICBASE:NO /DEBUG:FULL
        /INCREMENTAL:NO /MACHINE:X64 /NOLOGO /MANIFEST
        /MANIFESTUAC:"level='asInvoker' uiAccess='false'"
        /LTCGOUT:"${CMAKE_BINARY_DIR}/Release/${TARGET_NAME}.iobj"
    )
    # Link directories and libraries for Windows
    set(ICCPROFLIB_DIR "${PROJECT_ROOT_DIR}/Build/win/t/IccProfLib/Release")
    target_link_directories(${TARGET_NAME} PRIVATE "${ICCPROFLIB_DIR}")
    target_link_libraries(${TARGET_NAME} PRIVATE
        IccProfLib2
        kernel32.lib user32.lib gdi32.lib
        winspool.lib comdlg32.lib advapi32.lib
        shell32.lib ole32.lib oleaut32.lib
        uuid.lib odbc32.lib odbccp32.lib
    )
else()
    # Compiler options for Unix
    target_compile_options(${TARGET_NAME} PRIVATE
        -Wall -Wextra -Wpedantic -fPIC
        $<$<CONFIG:Release>:-O2 -DNDEBUG>
        $<$<CONFIG:Debug>:-Og -g>
    )
    # Link libraries for Unix
    target_link_libraries(${TARGET_NAME} PRIVATE
        ${TARGET_LIB_ICCPROFLIB}
    )
endif()

# Set output directories
set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_ROOT_DIR}/Testing/Release"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_ROOT_DIR}/Testing/Debug"
)

# Post-build command for Windows
if (WIN32)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "$<TARGET_FILE:${TARGET_NAME}>"
            "${PROJECT_ROOT_DIR}/Testing/$<IF:$<CONFIG:Debug>,iccApplyToLink_d.exe,iccApplyToLink.exe>"
        COMMENT "Copying build artifact (exe) to Testing directory..."
    )
endif()

# Installation
if (ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
    message(STATUS "Installation enabled. '${TARGET_NAME}' will be installed to bin.")
else()
    message(STATUS "Installation disabled for '${TARGET_NAME}'.")
endif()


# Final debug messages
message(STATUS "CMAKE_SOURCE_DIR resolved as: ${CMAKE_SOURCE_DIR}")
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "")