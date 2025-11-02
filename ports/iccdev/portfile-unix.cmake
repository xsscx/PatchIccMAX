vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xsscx/PatchIccMAX
    REF e6b7731326b3ef707c02cf71a7d07ea9238af3e6
    SHA512 502300a984d8074eba4ecfce8e345a5a0c05f9ceff13389299450c6a4524fb48bb09c91f59cb8232c8bf475064941cfda5db033f5ce23f0e4d0736ded30bbdca
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
    -DCMAKE_DEBUG_POSTFIX=
    # Hint paths if upstream does any find_library fallback
    "-DCMAKE_PREFIX_PATH=${CURRENT_PACKAGES_DIR};${CURRENT_INSTALLED_DIR}"
    "-DCMAKE_LIBRARY_PATH=${CURRENT_PACKAGES_DIR}/lib;${CURRENT_PACKAGES_DIR}/debug/lib"
    "-DCMAKE_INCLUDE_PATH=${CURRENT_INSTALLED_DIR}/include"
    # CRITICAL: tell IccXML to link the *target*, not a raw .lib path
    -DTARGET_LIB_ICCPROFLIB=IccProfLib2
)

# DO NOT override MSVC runtime; keep vcpkg defaults (/MD, /MDd)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    OPTIONS ${_COMMON_OPTS}
)

# --- Stage 1:
# If upstream ever renames these, swap the target names accordingly.
vcpkg_cmake_build(TARGET IccProfLib2)   # core color lib
vcpkg_cmake_build(TARGET IccXML2)       # XML lib depends on the core lib
vcpkg_cmake_install()

# --- Stage 2:
vcpkg_cmake_build()
vcpkg_cmake_install()

# Fix CMake package layout if upstream uses a custom subdir
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/reficcmax)

# Housekeeping
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

# Policies actually needed
set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)
set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)