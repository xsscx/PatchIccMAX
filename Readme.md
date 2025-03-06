# 🛠️ [PR120](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/120)

### Runner Status

[![PR119-Latest](https://github.com/xsscx/PatchIccMAX/actions/workflows/PR119-Latest.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/PR119-Latest.yaml)
[![PR119-Scan-Build](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-ubuntu-clang-scan.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-ubuntu-clang-scan.yaml)
[![PR119-Unit-Test](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-xnu-debug-asan.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-xnu-debug-asan.yaml)

**Last Updated:** 27-MAR-2025 at 0700 EDT by David Hoyt

### iccMAX Graph

#### Before
![iccMAX GraphViz](https://xss.cx/2025/03/22/img/iccMAX-graph.svg)

#### After
![iccMAX Target Graph](https://xss.cx/2025/03/24/img/iccMAX_Graph_Latest.png)

#### iccPngDump Tool
![iccPngDump Graph](https://xss.cx/2025/03/24/img/iccPngDump.png)

---

## CMake Config Update 

**PR119** aligned the build system for `IccProfLib`, `IccXML` + `Tools` for `Windows, Linux, and macOS`. 
- Added `iccPngDump` to `Tools`. 
- Updated Documentation
- Consolidated Runners

### Why This Matters

You may have relied on:
- **Legacy Visual Studio `.vcxproj` files**
- **Roll Your Own CMake configurations on UNIX**

These approaches should be deprecated in the future.

**CMake is the _supported cross platform & toolchain build system_**, offering:
- Unified builds across platforms and compilers (MSVC, Clang, GCC)
- Consistent static/dynamic linking via `vcpkg` or system packages
- Modern testing, CI integration, and profiling support

---

## Cmake Migration at a Glance

| Platform        | Old Method                     | New Method (PR119)                            |
|----------------|----------------------------------|------------------------------------------------|
| Windows         | `.vcxproj` + manual includes    | `cmake -G "Visual Studio 17 2022"`            |
| UNIX/Linux/macOS| `make` or broken `CMakeLists`   | `cmake && make` via modular `Build/Cmake`     |

---

PR119 Highlights

- Builds cross-platform: MSVC, Clang, GCC
- Modular CMakeLists.txt setup per tool
- Adds new tool: iccPngDump
- Build matrix: Windows, Linux, macOS (ARM/x64)
- feat(tools): add iccPngDump, refactor cmake configs
- build(cmake): support static + shared Windows builds
- docs(tools): add Readme for iccPngDump usage

Known-Good Runners (Example PR119-win-msvc-release)
 
- Uses vcpkg cache
- Restores + installs full dependency set (dynamic & static)
- Clones + checks out PR119 cleanly
- Powershell-based build using cmake + MSBuild
- Artifacts + logs uploaded post-build
---

## Git Diff Summary: `master...pr-119`

### Reproduction

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/119/head:pr-119
git checkout pr-119
git diff --stat origin/master...
```

#### Expected Output

```
 Build/Cmake/CMakeLists.txt                                    | 667 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 Build/Cmake/IccProfLib/CMakeLists.txt                         | 100 +++++++++++++++++---------
 Build/Cmake/IccXML/CMakeLists.txt                             | 123 ++++++++++++++++++++++---------
 Build/Cmake/Tools/DemoIccMAXCmm/CMakeLists.txt                |  87 ++++++++++++++++++++++
 Build/Cmake/Tools/IccPngDump/CMakeLists.txt                   |  70 ++++++++++++++++++
 Build/Cmake/Tools/wxProfileDump/CMakeLists.txt                |  57 ++++++++++++---
 Build/Cmake/vcpkg-toolchain.cmake                             |  61 ++++++++++++++++
 Tools/CmdLine/IccApplyNamedCmm/CMakeLists.txt                 |   1 -
 Tools/CmdLine/IccApplyProfiles/CMakeLists.txt                 |   1 -
 Tools/CmdLine/IccPngDump/Readme.md                            | 139 +++++++++++++++++++++++++++++++++++
 Tools/CmdLine/IccPngDump/iccPngDump.cpp                       | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/.github/workflows/PR119-Latest.yaml                   | 195 +++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/BugReportSamples/pr119.md                             | 377 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/Build/VS2022C/build.ps1                               |   6 +-
 contrib/Build/cmake/build_master_branch.sh                    |   8 +--
 contrib/Build/cmake/build_master_branch.zsh                   |   4 +-
 contrib/Build/vcpkg/Readme.md                                 | 138 ++++++++++++++++++++++++-----------
 contrib/CalcTest/check_profiles.zsh                           |  21 +++++-
 contrib/DGML/Readme.md                                        |  64 +++++++++++++++++
 contrib/DGML/iccMAX_Graph.zip                                 | Bin 0 -> 8498644 bytes
 contrib/Readme.md                                             | 533 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------
 contrib/UnitTest/TestCIccTagXmlProfileSequenceId.sh           |   8 +--
 contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh |  76 ++++++++++----------
 contrib/UnitTest/iccMAX-cicd-build-checks.md                  |  14 ++++
 contrib/UnitTest/iccMAX-cicd-build-checks.sh                  |  73 +++++++++++++++++++
 contrib/UnitTest/zsh_ubuntu_checks..md                        |  17 +++++
 contrib/UnitTest/zsh_ubuntu_checks.zsh                        | 171 +++++++++++++++++++++++++++++++++++++++++++
 vcpkg.json                                                    |  14 ++++
 28 files changed, 2894 insertions(+), 563 deletions(-)
```

### Reproduction | GNU

```
export CXX=g++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/119/head:pr-119
git checkout pr-119
cd Build
sudo apt-get install -y libpng-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_BUILD_TYPE=Debug -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -Wno-dev -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
cd ../Testing/
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

#### Expected Output

```
find . -type f \( -perm -111 -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -print ``` 
./Tools/IccRoundTrip/iccRoundTrip
./Tools/IccDumpProfile/iccDumpProfile
./Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
./Tools/IccApplyProfiles/iccApplyProfiles
./Tools/IccApplyToLink/iccApplyToLink
./Tools/IccSpecSepToTiff/iccSpecSepToTiff
./Tools/IccToXml/iccToXml
./Tools/IccApplyNamedCmm/iccApplyNamedCmm
./Tools/IccFromXml/iccFromXml
./Tools/IccPngDump/iccPngDump
./Tools/IccTiffDump/iccTiffDump
./Tools/IccFromCube/iccFromCube
./IccProfLib/libIccProfLib2.so.2.1.25
./IccProfLib/libIccProfLib2-static.a
./IccXML/libIccXML2.so.2.1.25
./IccXML/libIccXML2-static.a
```

### Reproduction | Clang

```
export CXX=clang++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/119/head:pr-119
git checkout pr-119
cd Build
sudo apt-get install -y libpng-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
cd ../Testing/
```

#### Expected Output

```
find . -type f \( -perm -111 -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -print
./Tools/IccRoundTrip/iccRoundTrip
./Tools/IccDumpProfile/iccDumpProfile
./Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
./Tools/IccApplyProfiles/iccApplyProfiles
./Tools/IccApplyToLink/iccApplyToLink
./Tools/IccSpecSepToTiff/iccSpecSepToTiff
./Tools/IccToXml/iccToXml
./Tools/IccApplyNamedCmm/iccApplyNamedCmm
./Tools/IccFromXml/iccFromXml
./Tools/IccPngDump/iccPngDump
./Tools/IccTiffDump/iccTiffDump
./Tools/IccFromCube/iccFromCube
./IccProfLib/libIccProfLib2.so.2.1.25
./IccProfLib/libIccProfLib2-static.a
./IccXML/libIccXML2.so.2.1.25
./IccXML/libIccXML2-static.a
```

### Reproduction Windows

#### Prerequisites

- Windows 10/11
- Visual Studio 2022 (with C++ Desktop Development workload)
- PowerShell
- Administrator or Developer command prompt

---

#### Setup: Environment & Dependencies

```
mkdir C:\test\
cd C:\test\
```

### Clone vcpkg and bootstrap

```
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat -disableMetrics
.\vcpkg.exe integrate install
```

#### Install required libraries (both dynamic and static)

```
.\vcpkg.exe install `
  libpng `
  nlohmann-json:x64-windows `
  nlohmann-json:x64-windows-static `
  libxml2:x64-windows `
  libxml2:x64-windows-static `
  tiff:x64-windows `
  tiff:x64-windows-static `
  wxwidgets:x64-windows `
  wxwidgets:x64-windows-static
```

#### Clone and Checkout ICCMAX PR

```
cd C:\test\
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
```

#### Checkout pull request #119

```
git fetch origin pull/119/head:pr-119
git checkout pr-119
```

---

#### Configure & Build Example (Debug)

```
cd Build
mkdir win
cd win
cmake -S ..\Cmake -B . -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_BUILD_TYPE=Debug `
  -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake `
  -DCMAKE_C_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" `
  -DCMAKE_CXX_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" `
  -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" `
  -DENABLE_TOOLS=ON `
  -DENABLE_SHARED_LIBS=ON `
  -DENABLE_STATIC_LIBS=ON `
  -DENABLE_TESTS=ON `
  -DENABLE_INSTALL_RIM=ON `
  -DENABLE_ICCXML=ON `
  -DENABLE_SPECTRE_MITIGATION=OFF `
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON `
  --graphviz=iccMAX-project.dot

cmake --build . --config Debug -- /m /maxcpucount:32
```

##### Result

```
C:\test\pr119\PatchIccMAX\Build\Cmake\Tools\IccPngDump\Debug\iccPngDump.exe
[INFO] Starting iccPngDump...
Built with IccProfLib version 2.2.5
Built with LibPNG version 1.6.46
Usage: iccPngDump <input.png> [output.icc]
  Extracts the ICC profile from a PNG file.
```

## CMake Build System Updates (Cross-Platform)

PR119 modified the Cmake Build Configurations in the `Build/Cmake/` directory, moving towards a modern cross-platform build system.

#### Updates:

- **Top-Level CMake Configuration**
  - `CMakeLists.txt` enables unified configuration for tools, libraries, and flags.
  - Supports toggles for shared/static linking, ICCXML, and optional RIM inclusion.
  - No need to maintain `.vcxproj` files

- **Tool-Specific Subdirectories**
  - Each tool (e.g., `IccPngDump`, `IccDumpProfile`, `IccToXml`) is configured via `CMakeLists.txt` under `Build/Cmake/Tools/`.
  - Adds modularity, CI targeting, and selective builds.

- **Cross-Platform Toolchain Support**
  - Adds support for Clang, GCC, and MSVC via conditional platform logic.

### Triples Testing Summary

| **Operating System**       | **Kernel Version**                                | **Architecture**     | **Environment**                       |
|----------------------------|--------------------------------------------------|-----------------------|---------------------------------------|
| macOS                      | Darwin Kernel Version 24.1.0                     | ARM64                | RELEASE_ARM64_T8103                   |
| macOS                      | Darwin Kernel Version 24.1.0                     | x86_64               | RELEASE_X86_64                        |
| WSL2 (Linux)               | 5.15.153.1-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro   | 10.0.26100                                       | x86_64               | Visual Studio 17.12.1                 |

#### PR Preflight Checks
1. Build on Linux, macOS & Windows.
2. Create ICC Profiles.

### Dependencies
- `libpng-dev`: Required for Png Support.
- `libxml2`: Required for XML support.
- `libwxgtk3.2-dev`: Required for GUI support.
- `nlohmann-json3-dev`: Enables JSON parsing for configuration files.
- `libtiff`: Supports TIFF image manipulation for image processing tools.
- `wxWidgets`: Cross-platform GUI framework for the basic profile viewer.

---

## [Scan Build](https://github.com/xsscx/PatchIccMAX/actions/runs/14046632061)

```
Build - scan-build results
User:        root@Mac-1742852499290.local
Working Directory: /Users/runner/work/PatchIccMAX/PatchIccMAX/DemoIccMAX/Build
Command Line:      make -j3
Clang Version:     Homebrew clang version 17.0.6
Date:              Mon Mar 24 21:48:47 2025

Bug Summary
Bug Type                                      Quantity
------------------------------------------------------
All Bugs                                      65

Logic error
  Assigned value is garbage or undefined       1
  Dereference of null pointer                  1
  Garbage return value                         1
  Result of operation is garbage or undefined  4
  Uninitialized argument value                 3

Memory error
  Memory leak                                  1
  Use of zero allocated                        1
  Use-after-free                               3

Unused code
  Dead assignment                             22
  Dead increment                               4
  Dead initialization                         22
  Dead nested assignment                       2
```

## Legacy Overhang

### PR119 Analysis

- **Total files scanned**: 125 `.cpp` / `.h`
- Source: `PatchIccMAX-pr119.zip`

### TODO in future PR's

| Pattern        | Count | Risk/Notes |
|----------------|-------|------------|
| `C-style casts`       | 3,125 | Manual casting, fragile and unsafe in C++ |
| `#define`             | 358   | Preprocessor macros, often legacy patterns |
| `#ifdef`              | 218   | Conditional compilation, complex flow |
| `char*`               | 514   | Raw strings; consider `std::string` |
| `sprintf`             | 714   | Buffer overflows — use `snprintf` |
| `memcpy`              | 247   | Manual memory handling — bounds checks required |
| `printf`              | 424   | Replace with safe logging abstraction |
| `free`                | 213   | Manual memory — replace with RAII |
| `malloc`              | 103   | Raw allocation — use smart pointers |
| `void*`               | 88    | Unsafe, untyped memory |
| `strcpy`              | 40    | Overflow vector |

---

### Migration Shims

#### Potential `printf` Wrapper

```
#ifdef MODERNIZE_PRINTF
#include <stdio.h>
#include <stdarg.h>
void safe_printf(const char* fmt, ...) {
    char buffer[1024];
    va_list args;
    va_start(args, fmt);
    vsnprintf(buffer, sizeof(buffer), fmt, args);
    va_end(args);
    fputs(buffer, stdout);
}
#define printf(...) safe_printf(__VA_ARGS__)
#endif
```

#### Potential `sprintf` Replacement

```
#define SAFE_SPRINTF(dest, size, ...) snprintf(dest, size, __VA_ARGS__)
// Example:
SAFE_SPRINTF(buf, sizeof(buf), "Value: %d", x);
```

#### Potential Memory Change

```
// Old
char *buf = (char*)malloc(100);

// New
std::unique_ptr<char[]> buf(new char[100]);
```
