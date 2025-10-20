#
# iccApplySearch CMakeLists.txt | IccDEV Project
# Copyright (©) 2025 The International Color Consortium. All rights reserved.
#
#
# Last Updated: 18-OCT-2025 at 1200Z by David Hoyt
#
# Changes:      ADD iccApplySearch
#
#
# TODO: Refactor Debug, Release, Asan
#                       Collapse 3-tier CMakeLists.txt, Housekeeping
#                               Refactor Base Configs & logging to .mk's
#

# cmake_minimum_required(VERSION 3.2)
# ---- Project ----
project(iccApplySearch)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ---- Dependencies ----
# Try to use system or installed nlohmann_json first.
find_package(nlohmann_json QUIET)

# If not found, define a local header-only fallback.
if (NOT TARGET nlohmann_json::nlohmann_json)
    message(STATUS "nlohmann_json not found — using local header-only fallback")
    add_library(nlohmann_json INTERFACE)
    target_include_directories(nlohmann_json INTERFACE
        ${CMAKE_SOURCE_DIR}/../third_party/nlohmann/json/include
    )
    add_library(nlohmann_json::nlohmann_json ALIAS nlohmann_json)
endif()

# ---- Sources ----
# Reminder: CMAKE_SOURCE_DIR is Build/Cmake; the repo root is two levels up.
set(SRC_ROOT "${CMAKE_SOURCE_DIR}/../..")

set(SOURCES
  "${SRC_ROOT}/Tools/CmdLine/IccApplySearch/iccApplySearch.cpp"
  "${SRC_ROOT}/Tools/CmdLine/IccCommon/IccJsonUtil.cpp"
  "${SRC_ROOT}/Tools/CmdLine/IccCommon/IccCmmConfig.cpp"
  "${SRC_ROOT}/IccProfLib/IccCmmSearch.cpp"
)

set(PRIVATE_INCLUDES
  "${SRC_ROOT}/Tools/CmdLine/IccApplySearch"
  "${SRC_ROOT}/Tools/CmdLine/IccCommon"
)

# ---- Target ----
if(NOT TARGET iccApplySearch)
  add_executable(iccApplySearch ${SOURCES})

  target_include_directories(iccApplySearch PRIVATE ${PRIVATE_INCLUDES})

  target_link_libraries(iccApplySearch PRIVATE
    ${TARGET_LIB_ICCPROFLIB}
    IccXML2
    nlohmann_json::nlohmann_json
  )

  if(ENABLE_INSTALL_RIM)
    install(TARGETS iccApplySearch DESTINATION ${CMAKE_INSTALL_BINDIR})
  endif()
else()
  message(STATUS "iccApplySearch already defined; skipping.")
endif()