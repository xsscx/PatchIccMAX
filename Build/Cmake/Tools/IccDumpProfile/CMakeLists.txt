#
# IccDumpProfile in Project_Root/Build/Cmake/Tools/IccDumpProfile/CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
#
# Last Updated: 02-DEC-2024 by David Hoyt
#
# Changes: Modified Build/Cmake/CMakelists.txt
#          Added explicit linker paths
#          Improved debug output for cross-platform support
#

# Log the entry into the CMake file
message(STATUS "#############################################################################################")
message(STATUS "Entering IccDumpProfile in Project_Root/Build/Cmake/Tools/IccDumpProfile/CMakeLists.txt .....")

# Define the project
project(IccDumpProfile)

# Define target name
set(TARGET_NAME "IccDumpProfile")

# Determine project root and source paths
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
set(SRC_PATH "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccDumpProfile")
set(SOURCES "${SRC_PATH}/iccDumpProfile.cpp")

# Ensure source file exists
if (NOT EXISTS "${SOURCES}")
    message(FATAL_ERROR "Source file not found at: ${SOURCES}. Verify the file exists.")
endif()

# Add executable target
add_executable(${TARGET_NAME} ${SOURCES})

# Include directories
target_include_directories(${TARGET_NAME} PRIVATE
    "${PROJECT_ROOT_DIR}/IccProfLib"
)

# Platform-specific options
if (WIN32)
    # Compiler options for Windows
    target_compile_options(${TARGET_NAME} PRIVATE
        /MP /GS /W3 /wd4996 /Gy /Zc:wchar_t /Zc:inline
        /fp:precise /DWIN32 /D"_VC80_UPGRADE=0x0710"
        /D"_MBCS" /GF /MT /FC /diagnostics:column
        $<$<CONFIG:Release>:/O2 /Ob1>
    )
    # Linker options for Windows
    target_link_options(${TARGET_NAME} PRIVATE
        /SUBSYSTEM:CONSOLE /DYNAMICBASE:NO /DEBUG:FULL
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
else()
    # Compiler options for Unix
    target_compile_options(${TARGET_NAME} PRIVATE
        -Wall -Wextra -Wpedantic -fPIC
        $<$<CONFIG:Release>:-O2 -DNDEBUG>
    )
    # Link libraries for Unix
    target_link_libraries(${TARGET_NAME} PRIVATE
        ${TARGET_LIB_ICCPROFLIB}
    )
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
            "${PROJECT_ROOT_DIR}/Testing/$<IF:$<CONFIG:Debug>,IccDumpProfile_d.exe,IccDumpProfile.exe>"
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

message(STATUS "Exiting IccDumpProfile in Project_Root/Build/Cmake/Tools/IccDumpProfile/CMakeLists.txt")
message(STATUS "######################################################################################")






