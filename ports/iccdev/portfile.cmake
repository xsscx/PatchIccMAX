vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/iccDEV
    REF b4a829086a541868319d6acdee23d71fec5cf95c
    SHA512 98f3df7d41fb75f441143b1b113228b5ff001f1494a4ef878dcc094608291f9d2393770472b08ff9563c68a9febb1c5adf5be17d8c921dea84dd8fdeddded122
)

message(STATUS "Configuring iccdev for platform: ${VCPKG_TARGET_IS_WINDOWS} / ${VCPKG_TARGET_IS_LINUX} / ${VCPKG_TARGET_IS_OSX}")

if(VCPKG_TARGET_IS_WINDOWS)
    message(STATUS "Applying Windows-specific build configuration")
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/iccDEV
    REF b4a829086a541868319d6acdee23d71fec5cf95c
    SHA512 98f3df7d41fb75f441143b1b113228b5ff001f1494a4ef878dcc094608291f9d2393770472b08ff9563c68a9febb1c5adf5be17d8c921dea84dd8fdeddded122
)

# -----------------------------------------------------------------------------
# Environment and dependency setup
# -----------------------------------------------------------------------------
list(APPEND CMAKE_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include")
set(EXTRA_COMPILE_FLAGS "/I${CURRENT_INSTALLED_DIR}/include")

set(CMAKE_PREFIX_PATH "${CURRENT_INSTALLED_DIR}/share")

# -----------------------------------------------------------------------------
# Source path and build directory
# -----------------------------------------------------------------------------
set(_src "${SOURCE_PATH}/Build/Cmake")
set(_bld "${CURRENT_BUILDTREES_DIR}/manual-x64-windows-rel")

file(REMOVE_RECURSE "${_bld}")
file(MAKE_DIRECTORY "${_bld}")

message(STATUS "🔧 Configuring and building iccdev from: ${_src}")

# -----------------------------------------------------------------------------
# Manual configure / build / install
# -----------------------------------------------------------------------------
vcpkg_execute_required_process(
    COMMAND ${CMAKE_COMMAND}
        -S "${_src}"
        -B "${_bld}"
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}
        -DCMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT_DIR}/scripts/buildsystems/vcpkg.cmake
        -DVCPKG_MANIFEST_MODE=OFF
        -DCMAKE_POLICY_DEFAULT_CMP0144=NEW
        "-DCMAKE_INCLUDE_PATH=${CURRENT_INSTALLED_DIR}/include"
        "-DCMAKE_LIBRARY_PATH=${CURRENT_INSTALLED_DIR}/lib"
        "-DCMAKE_PREFIX_PATH=${CURRENT_INSTALLED_DIR}/share"
        -DENABLE_TOOLS=ON
        -DENABLE_SHARED_LIBS=ON
        -DENABLE_STATIC_LIBS=ON
        -DENABLE_TESTS=OFF
        -DENABLE_INSTALL_RIM=ON
        -DENABLE_ICCXML=ON
    WORKING_DIRECTORY "${_bld}"
    LOGNAME configure-manual
)

vcpkg_execute_required_process(
    COMMAND ${CMAKE_COMMAND} --build "${_bld}" --config Release --parallel
    WORKING_DIRECTORY "${_bld}"
    LOGNAME build-manual
)

vcpkg_execute_required_process(
    COMMAND ${CMAKE_COMMAND} --install "${_bld}" --config Release
    WORKING_DIRECTORY "${_bld}"
    LOGNAME install-manual
)

# -----------------------------------------------------------------------------
# Post-install cleanup and warning suppression
# -----------------------------------------------------------------------------
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/reficcmax")
    message(STATUS "✅ Found reficcmax CMake config, skipping redundant fixup.")
else()
    # Move CMake config from lib/cmake to share/${PORT}/cmake if present
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake")
        vcpkg_cmake_config_fixup(PACKAGE_NAME iccdev CONFIG_PATH lib/cmake)
    endif()
endif()

# Relocate any executable tools to tools/${PORT}
vcpkg_copy_tools(
    TOOL_NAMES
        iccApplyNamedCmm
        iccApplyToLink
        iccDumpProfile
        iccFromCube
        iccFromXml
        iccJpegDump
        iccRoundTrip
        iccToXml
        iccV5DspObsToV4Dsp
    AUTO_CLEAN
)

# Apply policies to silence validation mismatches
set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)
set(VCPKG_POLICY_SKIP_LIB_CMAKE_MERGE_CHECK enabled)
set(VCPKG_POLICY_ALLOW_EXES_IN_BIN enabled)

message(STATUS "✅ Build completed; performing cleanup and license install.")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)
set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)

message(STATUS "✅ iccdev built and installed successfully.")

elseif(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_OSX OR VCPKG_TARGET_IS_UNIX)
    message(STATUS "Applying Unix-specific build configuration")
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/iccDEV
    REF b4a829086a541868319d6acdee23d71fec5cf95c
    SHA512 98f3df7d41fb75f441143b1b113228b5ff001f1494a4ef878dcc094608291f9d2393770472b08ff9563c68a9febb1c5adf5be17d8c921dea84dd8fdeddded122
)

# Make libxml2/iconv headers visible
list(APPEND CMAKE_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include")

# Common options for one configure
set(_COMMON_OPTS
    -DENABLE_TESTS=OFF
    -DENABLE_INSTALL_RIM=ON
    -DENABLE_ICCXML=ON
    -DENABLE_SHARED_LIBS=ON
    -DENABLE_STATIC_LIBS=ON
    -DENABLE_TOOLS=ON
    "-DCMAKE_PREFIX_PATH=${CURRENT_PACKAGES_DIR};${CURRENT_INSTALLED_DIR}"
    "-DCMAKE_LIBRARY_PATH=${CURRENT_PACKAGES_DIR}/lib;${CURRENT_PACKAGES_DIR}/debug/lib"
    "-DCMAKE_INCLUDE_PATH=${CURRENT_INSTALLED_DIR}/include"
    -DTARGET_LIB_ICCPROFLIB=IccProfLib2
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    OPTIONS ${_COMMON_OPTS}
)

vcpkg_cmake_build(TARGET IccProfLib2)
vcpkg_cmake_build(TARGET IccXML2)
vcpkg_cmake_install()

vcpkg_cmake_build()
vcpkg_cmake_install()

# Fix CMake package layout if upstream uses custom subdir
vcpkg_cmake_config_fixup(PACKAGE_NAME iccdev CONFIG_PATH lib/cmake)

# Relocate tool executables and apply policies
vcpkg_copy_tools(
    TOOL_NAMES
        iccApplyNamedCmm
        iccApplyToLink
        iccDumpProfile
        iccFromCube
        iccFromXml
        iccJpegDump
        iccRoundTrip
        iccToXml
        iccV5DspObsToV4Dsp
    AUTO_CLEAN
)

set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)
set(VCPKG_POLICY_SKIP_LIB_CMAKE_MERGE_CHECK enabled)
set(VCPKG_POLICY_ALLOW_EXES_IN_BIN enabled)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)
set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)
else()
    message(FATAL_ERROR "Unsupported platform for iccdev build")
endif()

# Common install directives (if any) can be added here
