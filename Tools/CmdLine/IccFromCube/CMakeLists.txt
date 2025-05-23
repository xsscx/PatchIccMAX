# 
# IccFromCube CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 03-DEC-2024 by David Hoyt
#
# Changes: 	Remove hardcoded build args and debugging output from my prior commit
#						
#						
# TODO: Refactor Debug, Release, Asan 
# 			Collapse 3-tier CMakeLists.txt, Housekeeping
#				Refactor Base Configs & logging to .mk's 
#

# Minimum CMake Version
cmake_minimum_required(VERSION 3.5)

# Project Definition
project(iccFromCube)

# Set C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set Architecture (x86_64 Only)
#set(CMAKE_OSX_ARCHITECTURES "x86_64")

# Source Files
set(SOURCES
  iccFromCube.cpp
)

# Add Executable
add_executable(iccFromCube ${SOURCES})

# Find macOS SDK Path
# execute_process(COMMAND xcrun --show-sdk-path OUTPUT_VARIABLE MACOS_SDK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)

# Include Directories
include_directories(
  ${CMAKE_SOURCE_DIR}/../../../IccProfLib
  ${CMAKE_SOURCE_DIR}/../../../IccXML
  /usr/include
)

# Link Directories
link_directories(
  ${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib
  ${CMAKE_SOURCE_DIR}/../../../Build/IccXML
)

# Link Libraries
target_link_libraries(iccFromCube
  IccProfLib2
  IccXML2
)

# Additional Compiler Flags
target_compile_options(iccFromCube PRIVATE)

# Additional Linker Flags
target_link_options(iccFromCube PRIVATE
  -L${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib
  -L${CMAKE_SOURCE_DIR}/../../../Build/IccXML
)
