# 🛠️ [PR119](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/119)

### Runner Status

[![PR119-Latest](https://github.com/xsscx/PatchIccMAX/actions/workflows/PR119-Latest.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/PR119-Latest.yaml)

**Last Updated:** 25-MAR-2025 at 0935 EDT by David Hoyt

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
 Build/Cmake/CMakeLists.txt                     | 667 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------
 Build/Cmake/IccProfLib/CMakeLists.txt          | 100 ++++++++++++++++++---------
 Build/Cmake/IccXML/CMakeLists.txt              | 123 +++++++++++++++++++++++----------
 Build/Cmake/Tools/DemoIccMAXCmm/CMakeLists.txt |  87 +++++++++++++++++++++++
 Build/Cmake/Tools/IccPngDump/CMakeLists.txt    |  70 +++++++++++++++++++
 Build/Cmake/Tools/wxProfileDump/CMakeLists.txt |  57 ++++++++++++---
 Build/Cmake/vcpkg-toolchain.cmake              |  61 +++++++++++++++++
 Tools/CmdLine/IccApplyNamedCmm/CMakeLists.txt  |   1 -
 Tools/CmdLine/IccApplyProfiles/CMakeLists.txt  |   1 -
 Tools/CmdLine/IccPngDump/Readme.md             | 139 +++++++++++++++++++++++++++++++++++++
 Tools/CmdLine/IccPngDump/iccPngDump.cpp        | 434 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/.github/workflows/PR119-Latest.yaml    | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/BugReportSamples/pr119.md              | 266 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/Build/VS2022C/build.ps1                |   6 +-
 contrib/Build/cmake/build_master_branch.sh     |   8 +--
 contrib/Build/cmake/build_master_branch.zsh    |   4 +-
 contrib/Build/vcpkg/Readme.md                  | 138 ++++++++++++++++++++++++++-----------
 contrib/DGML/Readme.md                         |  64 +++++++++++++++++
 contrib/DGML/iccMAX_Graph.zip                  | Bin 0 -> 8498644 bytes
 contrib/Readme.md                              | 487 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------
 vcpkg.json                                     |  14 ++++
 21 files changed, 2400 insertions(+), 522 deletions(-)
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

## Scan Build

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

### Build Examples

#### Optional: Build All Configurations with One-Liners

##### Test

```
cd C:\test\
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX\Build\Cmake\
```

Each of the following one-liners builds the corresponding configuration and generates its own `.dot` graph file.

##### Debug
```
cmake -S . -B . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/DEBUG /OPT:REF /OPT:ICF /LTCG /LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -DENABLE_SPECTRE_MITIGATION=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --graphviz=iccMAX-Debug.dot
cmake --build . --config Debug -- /m /maxcpucount:32
```

##### Release
```
cmake -S . -B . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/DEBUG /OPT:REF /OPT:ICF /LTCG /LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -DENABLE_SPECTRE_MITIGATION=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --graphviz=iccMAX-Release.dot
cmake --build . --config Release -- /m /maxcpucount:32
```

##### RelWithDebInfo
```
cmake -S . -B . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/DEBUG /OPT:REF /OPT:ICF /LTCG /LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -DENABLE_SPECTRE_MITIGATION=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --graphviz=iccMAX-RelWithDebInfo.dot
cmake --build . --config RelWithDebInfo -- /m /maxcpucount:32
```

##### MinSizeRel
```
cmake -S . -B . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/DEBUG /OPT:REF /OPT:ICF /LTCG /LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -DENABLE_SPECTRE_MITIGATION=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --graphviz=iccMAX-MinSizeRel.dot
cmake --build . --config MinSizeRel -- /m /maxcpucount:32
```

##### Optional: Visualize the Build Graph

If [Graphviz](https://graphviz.org/download/) is installed, you can convert the `.dot` files to SVG:

```
dot -Tsvg iccMAX-Debug.dot -o iccMAX-Debug.svg
```

##### RelWithDebInfo

```
cmake -S . -B . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /O2 /Zi /GL /DEBUG /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/DEBUG /OPT:REF /OPT:ICF /LTCG /LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -DENABLE_SPECTRE_MITIGATION=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --graphviz=iccMAX-project.dot
cmake --build . --config RelWithDebInfo -- /m /maxcpucount:32
```

##### Graphviz

```
cmake -S . -B . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -DENABLE_SPECTRE_MITIGATION=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --graphviz=iccMAX-project.dot
dot -Tsvg .dot -o iccMAX-graph.svg
```

##### Debug with Config Log

```
cmake -S .  -B .  -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /I C:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON --graphviz=graph.dot . --trace-expand  2>&1 | Tee-Object cmake_trace.log
```

##### Debug with Build Log

```
cmake --build . --config Debug -- /v:diag /m > msbuild_diag.log 2>&1 
```

##### AST Dump

```
Get-ChildItem -Recurse Tools -Filter *.cpp | ForEach-Object { clang++ -Xclang -ast-dump -fsyntax-only -IC:/test/vcpkg/installed/x64-windows/include -I./IccProfLib -I./IccXML/IccLibXML $_.FullName *> (Join-Path $_.Directory.FullName "$($_.BaseName)-ast.txt") 2>> warnings.log }
```
