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

# Resolve the project root directory using CMAKE_SOURCE_DIR
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "CMAKE_SOURCE_DIR resolved as: ${CMAKE_SOURCE_DIR}")

# Avoid re-defining the target if it already exists
if (TARGET IccDumpProfile)
    message(WARNING "Target 'IccDumpProfile' is already defined. Skipping target creation.")
    return()
endif()

message(STATUS "Defining target 'IccDumpProfile'...")

# Define source path and file
set(SRC_PATH "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccDumpProfile")
set(SOURCES "${SRC_PATH}/iccDumpProfile.cpp")

if (NOT EXISTS "${SOURCES}")
    message(FATAL_ERROR "Source file not found at: ${SOURCES}. Verify the file exists.")
endif()
message(STATUS "Source file resolved as: ${SOURCES}")

# Add the executable target
set(TARGET_NAME "IccDumpProfile")
add_executable(${TARGET_NAME} ${SOURCES})
message(STATUS "Added executable target: ${TARGET_NAME}")

# Include directories
target_include_directories(${TARGET_NAME} PRIVATE
    "${PROJECT_ROOT_DIR}/IccProfLib"
)
message(STATUS "Added include directories for ${TARGET_NAME}")

# Compiler options
target_compile_options(${TARGET_NAME} PRIVATE
    /MP                           # Multi-processor compilation
    /GS                           # Enable security checks
    /W3                           # Warning level 3
    /wd4996                       # Disable deprecated API warnings
    /Gy                           # Enable function-level linking
    /Zc:wchar_t                   # Treat wchar_t as native type
    /Zc:inline                    # Remove unused inline functions
    /fp:precise                   # Enable precise floating-point model
    /DWIN32                       # Define WIN32 macro
    /D"_VC80_UPGRADE=0x0710"      # Define project-specific macro
    /D"_MBCS"                     # Define Multi-Byte Character Set macro
    /GF                           # Enable string pooling
    /MT                           # Use static runtime library
    /FC                           # Display full path in diagnostics
    /diagnostics:column           # Enable column-based diagnostics
    $<$<CONFIG:Release>:/O2 /Ob1> # Optimization for Release builds
)
message(STATUS "Compiler options set for ${TARGET_NAME}")

# Linker options
target_link_options(${TARGET_NAME} PRIVATE
    /SUBSYSTEM:CONSOLE            # Console application
    /DYNAMICBASE:NO               # Disable ASLR
    /DEBUG:FULL                   # Full debugging information
    /INCREMENTAL:NO               # Disable incremental linking
    /MACHINE:X64                  # Target x64 architecture
    /NOLOGO                       # Suppress linker logo
    /MANIFEST                     # Enable manifest generation
    /MANIFESTUAC:"level='asInvoker' uiAccess='false'" # User access control
)
message(STATUS "Linker options set for ${TARGET_NAME}")

# Link directories and required libraries
set(ICCPROFLIB_DIR "${PROJECT_ROOT_DIR}/Build/win/t/IccProfLib/Release")
target_link_directories(${TARGET_NAME} PRIVATE "${ICCPROFLIB_DIR}")

target_link_libraries(${TARGET_NAME} PRIVATE
    IccProfLib2                 # The main library
    kernel32.lib user32.lib gdi32.lib
    winspool.lib comdlg32.lib advapi32.lib
    shell32.lib ole32.lib oleaut32.lib
    uuid.lib odbc32.lib odbccp32.lib
)
message(STATUS "Linked libraries for ${TARGET_NAME}")

# Set output directories
set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_ROOT_DIR}/Testing/Release"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_ROOT_DIR}/Testing/Debug"
)
message(STATUS "Output directories set for ${TARGET_NAME}")

# Post-build command to copy the executable to the Testing directory
add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "$<TARGET_FILE:${TARGET_NAME}>"
        "${PROJECT_ROOT_DIR}/Testing/$<IF:$<CONFIG:Debug>,IccDumpProfile_d.exe,IccDumpProfile.exe>"
    COMMENT "Copying build artifact (exe) to Testing directory..."
)
message(STATUS "Added post-build step for ${TARGET_NAME}")

# Installation setup
if (ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
    message(STATUS "Installation enabled. '${TARGET_NAME}' will be installed to bin.")
else()
    message(STATUS "Installation disabled for '${TARGET_NAME}'.")
endif()


# Final debug messages
message(STATUS "CMAKE_SOURCE_DIR resolved as: ${CMAKE_SOURCE_DIR}")
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")


message(STATUS "Exiting IccDumpProfile in Project_Root/Build/Cmake/Tools/IccDumpProfile/CMakeLists.txt")
message(STATUS "######################################################################################")






