#########################################################################################
#
# wxDumpProfile Config | IccMAX Project
# Copyright (?) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Last Updated: 18-MAR-2025 1000 EDT by David Hoyt
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

cmake_minimum_required(VERSION 3.16)
project(iccDumpProfileGui)

# Define target name
set(TARGET_NAME "iccDumpProfileGui")

# Determine project root and source paths
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
set(SRC_PATH "${PROJECT_ROOT_DIR}/Tools/wxWidget/wxProfileDump")
set(ICCPROFLIB_PATH "${PROJECT_ROOT_DIR}/IccProfLib")

# Source files
set(SOURCES
    "${SRC_PATH}/wxProfileDump.cpp"
    "${ICCPROFLIB_PATH}/IccUtil.cpp"
)

# Ensure source files exist
foreach(SOURCE ${SOURCES})
    if (NOT EXISTS "${SOURCE}")
        message(FATAL_ERROR "Source file not found at: ${SOURCE}. Verify the file exists.")
    endif()
endforeach()

# Find wxWidgets
find_package(wxWidgets REQUIRED COMPONENTS core base)
include(${wxWidgets_USE_FILE})

# Add executable target
add_executable(${TARGET_NAME} ${SOURCES})

# Include directories
target_include_directories(${TARGET_NAME} PRIVATE
    "${ICCPROFLIB_PATH}"
    ${wxWidgets_INCLUDE_DIRS}
)

# Link Libraries
target_link_libraries(${TARGET_NAME} PRIVATE ${TARGET_LIB_ICCPROFLIB} ${wxWidgets_LIBRARIES})

# Platform-specific configurations
if (WIN32)
    # Windows Compiler and Linker Options
    target_compile_options(${TARGET_NAME} PRIVATE
        /MP /GS /W3 /wd4996 /Gy /Zc:wchar_t /Zc:inline
        /fp:precise /DWIN32 /D"_VC80_UPGRADE=0x0710"
        /D"_MBCS" /GF /MT /FC /diagnostics:column
        $<$<CONFIG:Release>:/O2 /Ob1>
    )
    target_link_options(${TARGET_NAME} PRIVATE
        /SUBSYSTEM:WINDOWS /DYNAMICBASE:NO /DEBUG:FULL
        /INCREMENTAL:NO /MACHINE:X64 /NOLOGO /MANIFEST
        /MANIFESTUAC:"level='asInvoker' uiAccess='false'"
    )

    # Link directories and libraries for Windows
    set(ICCPROFLIB_DIR "${PROJECT_ROOT_DIR}/Build/win/t/IccProfLib/Release")
    target_link_directories(${TARGET_NAME} PRIVATE "${ICCPROFLIB_DIR}")
    target_link_libraries(${TARGET_NAME} PRIVATE
        IccProfLib2
        kernel32.lib user32.lib gdi32.lib winspool.lib
        comdlg32.lib advapi32.lib shell32.lib ole32.lib
        oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
    )

elseif(APPLE)
    # macOS-specific settings
    target_compile_options(${TARGET_NAME} PRIVATE -Wall -Wextra -Wpedantic -fPIC)
    target_link_libraries(${TARGET_NAME} PRIVATE "-framework Cocoa")

else()
    # Linux/Unix Compiler Options
    target_compile_options(${TARGET_NAME} PRIVATE -Wall -Wextra -Wpedantic -fPIC)
    target_link_libraries(${TARGET_NAME} PRIVATE ${TARGET_LIB_ICCPROFLIB})
endif()

# Define output directories
set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_ROOT_DIR}/Testing/Release"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_ROOT_DIR}/Testing/Debug"
)

# Post-build command for Windows
if (WIN32)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "$<TARGET_FILE:${TARGET_NAME}>"
            "${PROJECT_ROOT_DIR}/Testing/$<IF:$<CONFIG:Debug>,IccDumpProfileGui_d.exe,IccDumpProfileGui.exe>"
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
