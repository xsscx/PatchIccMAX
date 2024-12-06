# 
# Configuration for wxProfileDump in Build/Cmake/Tools/wxProfileDump/CMakeLists.txt
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 05-DEC-2024 by David Hoyt
#
# Changes: 	Modified Build/Cmake/CMakelists.txt and others
#           Added to Logging , Debugging, and CI/CD Integration
#           Adjusted Cross Platform Build Args
#						
# TODO: Refactor Debug, Release, Asan 
#       Collapse 3-tier CMakeLists.txt, Housekeeping
#       Refactor Base Configs & logging to .mk's 
#

message(STATUS "######################################################################################")
message(STATUS "## Entering Config for wxProfileDump in Build/Cmake/Tools/wxProfileDump/CMakeLists.txt")

# Set Source Path
set(SRC_PATH ../../../..)
message(STATUS "SRC_PATH resolved as: ${SRC_PATH}")

# Set Sources
set(SOURCES ${SRC_PATH}/Tools/wxWidget/wxProfileDump/wxProfileDump.cpp)
message(STATUS "SOURCES resolved as:")
foreach(SOURCE_FILE IN LISTS SOURCES)
    message(STATUS "  ${SOURCE_FILE}")
endforeach()

# Set Target Name
set(TARGET_NAME iccDumpProfileGui)
message(STATUS "TARGET_NAME set as: ${TARGET_NAME}")

# Configure wxWidgets
set(wxWidgets_CONFIGURATION mswu)
message(STATUS "wxWidgets configuration set to: ${wxWidgets_CONFIGURATION}")

# Add Executable
message(STATUS "Adding executable target: ${TARGET_NAME}")
add_executable(${TARGET_NAME} ${SOURCES})
message(STATUS "Executable target ${TARGET_NAME} added with sources:")

foreach(SOURCE_FILE IN LISTS SOURCES)
    message(STATUS "  ${SOURCE_FILE}")
endforeach()

# Link Libraries
message(STATUS "  Linking libraries for target ${TARGET_NAME}:")
message(STATUS "  ICCProfLib Library: ${TARGET_LIB_ICCPROFLIB}")
message(STATUS "  wxWidgets Libraries: ${wxWidgets_LIBRARIES}")
target_link_libraries(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB} ${wxWidgets_LIBRARIES})

# Install Target
if(ENABLE_INSTALL_RIM)
    message(STATUS "Installing target ${TARGET_NAME} to ${CMAKE_INSTALL_BINDIR}")
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
else()
    message(STATUS "Installation of target ${TARGET_NAME} is disabled (ENABLE_INSTALL_RIM is OFF).")
endif()

message(STATUS "## Exiting Config for wxProfileDump in Build/Cmake/Tools/wxProfileDump/CMakeLists.txt")
message(STATUS "#####################################################################################")
