# Cmake Refactor Update | DemoIccMAX Project

**December 6, 2024** 

David Hoyt | [@h02332](https://x.com/h02332)

## Code

```
export CXX=clang++
https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX/Build
#
##
## Required: Dependencies for your Host
## XNU: brew install nlohmann-json libxml2 wxwidgets libtiff
## Linux: sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
## Windows vcpkg integrated: Use vcpkg.json
## Windows vcpkg classic: .\vcpkg.exe install nlohmann-json:x64-windows nlohmann-json:x64-windows-static libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static
##
## Choose a Branch
## ---
## git checkout msvc
## git checkout xnu
## ---
#
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev Cmake/
make clean
make -j$(nproc)
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)" || { echo "Error: Profile creation failed. Exiting."; exit 1; }
```

### Configure & Build Status for *Windows & UNIX*
### Build Status | Development Branch

| **Tool or Library**         | **Windows** | **macOS** | **Linux** | **WSL2** |
|-----------------------------|-------------|-----------|-----------|----------|
| iccApplyNamedCmm            | ✅          | ✅        | ✅        | ✅       |
| iccApplyProfiles            | ✅          | ✅        | ✅        | ✅       |
| iccApplyToLink              | ✅          | ✅        | ✅        | ✅       |
| iccDumpProfile              | ✅          | ✅        | ✅        | ✅       |
| iccFromCube                 | ✅          | ✅        | ✅        | ✅       |
| iccFromXml                  | ✅          | ✅        | ✅        | ✅       |
| iccToXml                    | ✅          | ✅        | ✅        | ✅       |
| iccRoundTrip                | ✅          | ✅        | ✅        | ✅       |
| iccSpecSepToTiff            | ✅          | ✅        | ✅        | ✅       |
| iccTiffDump                 | ✅          | ✅        | ✅        | ✅       |
| IccV5DspObsToV4Dsp          | ✅          | ✅        | ✅        | ✅       |
| wxProfileDump               | ✅          | ✅        | ✅        | ✅       |
| libIccProfLib2              | ✅          | ✅        | ✅        | ✅       |
| libIccProfLib2_DLL          | ✅          | ✅        | ✅        | ✅       |
| libIccProfLib2_CRTDLL       | ✅          | ✅        | ✅        | ✅       |
| libIccXML2                  | ✅          | ✅        | ✅        | ✅       |
| libIccXML2_CRTDLL           | ✅          | ✅        | ✅        | ✅       |
| DemoIccMAXCmm               | ✅          | ✅        | ✅        | ✅       |

## Latest [PR111](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/111)

- **Added Projects**:
  - `IccFromCube`
  - `IccV5DspObsToV4Dsp`
  - `IccApplyToLink`
- **Updated CMake Build Configurations**:
  - Adjusted cross-platform arguments.
  - Refactored logic for improved compatibility.

### Stats

```
[2024-12-03 12:05:48 ~/tmp/gnu/DemoIccMAX]% git diff --stat master...pr-111
 Build/Cmake/CMakeLists.txt                                | 167 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 Build/Cmake/RefIccMAXConfig.cmake.in                      |   1 -
 Build/Cmake/Tools/IccApplyToLink/CMakeLists.txt           |  38 +++++++++++++++++++++
 Build/Cmake/Tools/IccFromCube/CMakeLists.txt              |  30 +++++++++++++++++
 Build/Cmake/Tools/IccV5DspObsToV4Dsp/CMakeLists.txt       |  30 +++++++++++++++++
 Build/MSVC/BuildDefs.props                                |   7 ++--
 Tools/CmdLine/IccApplyNamedCmm/CMakeLists.txt             |  34 +++++++++----------
 Tools/CmdLine/IccApplyProfiles/CMakeLists.txt             |  38 +++++++++++----------
 Tools/CmdLine/IccApplyToLink/CMakeLists.txt               |  37 +++++++++++----------
 Tools/CmdLine/IccFromCube/CMakeLists.txt                  |  37 +++++++++++----------
 contrib/BugReportSamples/scan-build_14-sept-24_summary.md |  62 -----------------------------------
 contrib/Build/cmake/Readme.md                             | 345 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------------
 contrib/Build/cmake/build_clang_master_branch.sh          |   2 +-
 contrib/Build/cmake/build_master_branch.sh                |   2 +-
 contrib/Build/vcpkg/unset_default_triplet.ps1             | 334 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 contrib/Readme.md                                         | 135 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 16 files changed, 602 insertions(+), 697 deletions(-)
```

### Triples Summary

| **Operating System**       | **Kernel Version**                                | **Architecture**     | **Environment**                       |
|----------------------------|--------------------------------------------------|-----------------------|---------------------------------------|
| macOS                      | Darwin Kernel Version 24.1.0                     | ARM64                | RELEASE_ARM64_T8103                   |
| macOS                      | Darwin Kernel Version 24.1.0                     | x86_64               | RELEASE_X86_64                        |
| WSL2 (Linux)               | 5.15.153.1-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro   | 10.0.26100                                       | x86_64               | Visual Studio 17.12.1                 |

### PR Preflight Checks
1. Build on Linux, macOS & Windows.
2. Create ICC Profiles.

### Dependencies
- `libwxgtk3.2-dev`: Required for GUI support.
- `nlohmann-json3-dev`: Enables JSON parsing for configuration files.
- `libtiff`: Supports TIFF image manipulation for image processing tools.
- `wxWidgets`: Cross-platform GUI framework for the basic profile viewer.

---

## Build Instructions

PR & Project: Build on Unix & Windows on **arm64** and **x86_64** using **Clang**, **MSVC** and **GNU** C++ with the instructions provided below.

### Test [PR111](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/111) on *ubuntu-latest*

```
export CXX=clang++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/111/head:pr-111
git checkout pr-111
cd Build
sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev Cmake/
make clean
make -j$(nproc)
```

### **Clang** Build 

Copy and Paste into your Terminal:

```
# Set Clang++
export CXX=clang++
# change to /tmp dir
cd /tmp
# Build Project
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/xnu_build_master_branch.zsh)"
# change to ../Testing/ dir
cd ../Testing/
# Build ICC Profiles
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

### Windows Expected Output

**Clang Build Tools**

```
[2024-11-27 18:09:24] $ cd Build
$ make
...
[100%] Built target iccToXml
...
+ ../../Build/Tools/IccFromXml/iccFromXml RefIncW.xml RefIncW.icc
Profile parsed and saved correctly
...
Expecting 204 .icc color profiles...
-n ICC file count.. :
     204
...
 Clang Build Project and CreateAllProfiles Done!
```

### Windows **MSVC** Build

Copy and Paste into Powershell:

   ```powershell
   iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build.ps1").Content
   ```
### Expected Output   

Windows using **MSBuild Build** & **vcpkg** Tools

```
[100%] Built target iccToXml
...
+ ../../Build/Tools/IccFromXml/iccFromXml RefIncW.xml RefIncW.icc
Profile parsed and saved correctly
...
Expecting 204 .icc color profiles...
-n ICC file count.. :
     204
```

#### Windows Troubleshooter

```
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/windev_troubleshooter.ps1").Content
```

### **GNU C++** Build

Manually complete the Clone, Patch & Build process shown below on Ubuntu:

```
## **GNU C++** Build Instructions

### Clone the DemoIccMAX repository and PR111
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/111/head:pr-111
git checkout pr-111

# Apply the GCC Patch from the PatchIccMAX repository
# TODO: Analyze Scoping Issue, Fix Template, Re: GNU C++ Strict Checks vs Clang

# Save the diff as a patch file
cat <<EOF > gnu_cpp_pr111.patch
diff --git a/Tools/CmdLine/IccCommon/IccJsonUtil.cpp b/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
index 78a78cf..fcf0c6a 100644
--- a/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
+++ b/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
@@ -94,7 +94,6 @@ template <typename T>
 }

 // Explicit template instantiations
-template bool jsonToValue<int>(const json&, int&);
 template std::string arrayToJson<icUInt8Number>(icUInt8Number*, int);
 template std::string arrayToJson<icUInt16Number>(icUInt16Number*, int);
 template std::string arrayToJson<icUInt32Number>(icUInt32Number*, int);
EOF

# Apply the patch
git apply gnu_cpp_pr111.patch

# Verify the patch was applied successfully
git status

# Navigate to the Build directory
cd Build

# Install Deps
sudo apt-get install -y wx-common curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential libtiff-tools libtiff-opengl

# Configure the build with CMake
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev Cmake/

# Build the project
make -j$(nproc)

# change to ../Testing/ dir
cd ../Testing/

# Build ICC Profiles
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

### Expected Output | Linux DESKTOP 5.15.153.1-microsoft-standard-WSL2

```
[2024-11-27 18:29:09 ~/tmp/DemoIccMAX/Build]% uname -a
Linux DESKTOP 5.15.153.1-microsoft-standard-WSL2 #1 SMP Fri Mar 29 23:14:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
[2024-11-27 18:29:19 ~/tmp/tt/DemoIccMAX/Build]% make -j$(nproc)
[ 45%] Built target IccProfLib2-static
...
[100%] Built target iccDumpProfile

[2024-11-27 18:29:25 ~/tmp/DemoIccMAX/Build]% Tools/IccToXml/iccToXml
IccToXml built with IccProfLib Version 2.2.5, IccLibXML Version 2.2.5

[2024-11-27 18:31:15 ~/tmp/tt/DemoIccMAX/Build]% Tools/IccFromXml/iccFromXml
IccFromXml built with IccProfLib Version 2.2.5, IccLibXML Version 2.2.5

...
```

## Reproduction Hosts

```
Darwin Kernel Version 24.1.0: Thu Oct 10 21:05:14 PDT 2024; root:xnu-11215.41.3~2/RELEASE_ARM64_T8103 arm64
Darwin Kernel Version 24.1.0: Thu Oct 10 21:02:27 PDT 2024; root:xnu-11215.41.3~2/RELEASE_X86_64 x86_64
5.15.153.1-microsoft-standard-WSL2 #1 SMP Fri Mar 29 23:14:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
Microsoft Windows 11 Pro 10.0.26100 26100 & VisualStudio/17.12.1
```

## Q3/Q4 Bug Report

**Last Updated: 3 December 2024**

| **Category**                               | **Sep 12, 2024** | **Dec 3, 2024** | **Change** | **Comments**                                                                                              | **Priority** |
|--------------------------------------------|------------------|-----------------|------------|-----------------------------------------------------------------------------------------------------------|--------------|
| **All Bugs**                               | 111              | 62              | -49        | Significant reduction in bug count due to active efforts in cleanup and resolution.                       | -            |
| **API**                                    | 5                | 5               | No change  | API misuse remains consistent; attention needed for arguments passed as null.                             | **1**        |
| **Logic Errors**                           |                  |                 |            |                                                                                                           |              |
| Assigned value is garbage or undefined     | 1                | 1               | No change  | The assigned value garbage issue remains consistent across the last two reports.                          | **2**        |
| Called C++ object pointer is null          | 2                | -               | Resolved   | Handling of null pointers improved in the latest report.                                                  | **2**        |
| Dereference of null pointer                | 14               | 1               | -13        | A drastic reduction in null pointer dereference errors, attributed to improved code quality.              | **1**        |
| Garbage return value                       | -                | 1               | +1         | Issue reintroduced, highlighting potential regressions in code maintenance.                               | **4**        |
| Result of operation is garbage or undefined| -                | 4               | +4         | Issues persist and require further attention.                                                             | **4**        |
| Uninitialized argument value               | 3                | 3               | No change  | Uninitialized arguments remain the same as in the last report.                                            | **3**        |
| **Memory Errors**                          |                  |                 |            |                                                                                                           |              |
| Bad deallocator                            | 4                | 4               | No change  | Efforts in memory management stabilize but remain a concern.                                              | **2**        |
| Double free                                | 2                | 2               | No change  | Double free issues remain consistent across all reports.                                                  | **1**        |
| Memory leak                                | 13               | 1               | -12        | Improved handling of memory leaks with some residual issues.                                              | **1**        |
| Use-after-free                             | 9                | 3               | -6         | Reduction in use-after-free instances but requires continued effort.                                      | **1**        |
| Use of zero allocated                      | 1                | 1               | No change  | Issue persists in the latest report.                                                                      | **2**        |
| **Unix API (Memory)**                      |                  |                 |            |                                                                                                           |              |
| Allocator sizeof operand mismatch          | 1                | 1               | No change  | No change, suggesting this edge case issue is still unresolved.                                           | **2**        |
| **Unused Code**                            |                  |                 |            |                                                                                                           |              |
| Dead assignment                            | 30               | 20              | -10        | Dead assignments reduced by a significant margin in the latest efforts.                                   | **4**        |
| Dead increment                             | 4                | 3               | -1         | Slight improvement in addressing dead increments.                                                         | **5**        |
| Dead initialization                        | 21               | 22              | +1         | New cases of dead initialization introduced and require attention.                                        | **4**        |
| Dead nested assignment                     | 1                | 2               | +1         | New dead nested assignment identified in recent code additions.                                           | **5**        |

---

## Summary (Dec 3, 2024):

| **Category**                    | **Bug Type**                                  | **Quantity** | **Priority** |
|---------------------------------|-----------------------------------------------|--------------|--------------|
| **All Bugs**                    | Total Bug Count                               | 62           | -            |
| **API Issues**                  | Argument with 'nonnull' attribute passed null | 5            | **1**        |
| **Logic Errors**                | Assigned value is garbage or undefined        | 1            | **2**        |
|                                 | Dereference of null pointer                   | 1            | **1**        |
|                                 | Garbage return value                          | 1            | **4**        |
|                                 | Result of operation is garbage or undefined   | 4            | **4**        |
|                                 | Uninitialized argument value                  | 3            | **3**        |
| **Memory Errors**               | Bad deallocator                               | 4            | **2**        |
|                                 | Double free                                   | 2            | **1**        |
|                                 | Memory leak                                   | 1            | **1**        |
|                                 | Use of zero allocated                         | 1            | **2**        |
|                                 | Use-after-free                                | 3            | **1**        |
| **Unix API**                    | Allocator sizeof operand mismatch             | 1            | **2**        |
| **Unused Code**                 | Dead assignment                               | 20           | **4**        |
|                                 | Dead increment                                | 3            | **5**        |
|                                 | Dead initialization                           | 22           | **4**        |
|                                 | Dead nested assignment                        | 2            | **5**        |

---

### Insight:
1. **Fixes**:
   - **null pointer dereferences** & **memory leaks**.
   - TODO: **use-after-free** errors & uninitialized values.

2. **Refactor**:
   - Decreased occurrences of dead assignments but new dead initializations introduced.
   - Ongoing efforts at memory handling and code optimization.

3. **Progress**:
   - Total bugs reduced by **49**, indicating improvements in code quality and maintainability.

### TODO
- Refactor Bugs from Scan-build
- General housekeeping.
- Refactor CMakeLists.txt:
  - A logical block opening on line 212 (IF) closes on line 330 (ENDIF) with mismatched arguments.

## macOS Build and Dependency Summary

| **File**                                          | **Type**                                    | **Dependencies**                                                                                     |
|---------------------------------------------------|---------------------------------------------|-------------------------------------------------------------------------------------------------------|
| `IccProfLib/libIccProfLib2-static.a`             | Current ar archive                         | None                                                                                                  |
| `IccProfLib/libIccProfLib2.2.1.25.dylib`         | Mach-O 64-bit dynamically linked library    | `@rpath/libIccProfLib2.2.dylib`, Carbon, IOKit, libc++, libSystem                                    |
| `IccXML/libIccXML2.2.1.25.dylib`                 | Mach-O 64-bit dynamically linked library    | `@rpath/libIccXML2.2.dylib`, `@rpath/libIccProfLib2.2.dylib`, libxml2, Carbon, IOKit, libc++, libSystem |
| `IccXML/libIccXML2-static.a`                     | Current ar archive                         | None                                                                                                  |
| `Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp`    | Mach-O 64-bit executable                   | `@rpath/libIccProfLib2.2.dylib`, Carbon, IOKit, libc++, libSystem                                    |
| `Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm` | Mach-O 64-bit executable                   | `@rpath/libIccXML2.2.dylib`, `@rpath/libIccProfLib2.2.dylib`, libxml2, Carbon, IOKit, libc++, libSystem |
| `Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles` | Mach-O 64-bit executable                   | `@rpath/libIccXML2.2.dylib`, libtiff, `@rpath/libIccProfLib2.2.dylib`, libxml2, Carbon, IOKit, libc++, libSystem |
| `Tools/IccTiffDump/iccTiffDump`                  | Mach-O 64-bit executable                   | `@rpath/libIccProfLib2.2.dylib`, libtiff, Carbon, IOKit, libc++, libSystem                           |
| `Tools/IccFromXml/iccFromXml`                    | Mach-O 64-bit executable                   | `@rpath/libIccXML2.2.dylib`, `@rpath/libIccProfLib2.2.dylib`, libxml2, Carbon, IOKit, libc++, libSystem |
| `Tools/IccRoundTrip/iccRoundTrip`                | Mach-O 64-bit executable                   | `@rpath/libIccProfLib2.2.dylib`, Carbon, IOKit, libc++, libSystem                                    |
| `Tools/IccSpecSepToTiff/iccSpecSepToTiff`        | Mach-O 64-bit executable                   | `@rpath/libIccProfLib2.2.dylib`, libtiff, Carbon, IOKit, libc++, libSystem                           |
| `Tools/IccToXml/iccToXml`                        | Mach-O 64-bit executable                   | `@rpath/libIccXML2.2.dylib`, `@rpath/libIccProfLib2.2.dylib`, libxml2, Carbon, IOKit, libc++, libSystem |
| `Tools/IccFromCube/iccFromCube`                  | Mach-O 64-bit executable                   | `@rpath/libIccProfLib2.2.dylib`, Carbon, IOKit, libc++, libSystem                                    |

### macOS File Details

```
File: IccProfLib/libIccProfLib2-static.a
Type: IccProfLib/libIccProfLib2-static.a: current ar archive
Deps:
    IccProfLib/libIccProfLib2-static.a(IccApplyBPC.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccArrayBasic.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccArrayFactory.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccCAM.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccCmm.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccConvertUTF.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccEncoding.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccEnvVar.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccEval.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccIO.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccMatrixMath.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccMpeACS.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccMpeBasic.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccMpeCalc.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccMpeFactory.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccMpeSpectral.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccPrmg.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccPcc.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccProfile.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccSolve.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccSparseMatrix.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccStructBasic.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccStructFactory.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagBasic.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagComposite.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagDict.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagEmbedIcc.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagFactory.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagLut.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagMPE.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccTagProfSeqId.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccUtil.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccXformFactory.cpp.o):
    IccProfLib/libIccProfLib2-static.a(IccMD5.cpp.o):

File: IccProfLib/libIccProfLib2.2.1.25.dylib
Type: IccProfLib/libIccProfLib2.2.1.25.dylib: Mach-O 64-bit dynamically linked shared library x86_64
Deps:
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: IccXML/libIccXML2.2.1.25.dylib
Type: IccXML/libIccXML2.2.1.25.dylib: Mach-O 64-bit dynamically linked shared library x86_64
Deps:
        @rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: IccXML/libIccXML2-static.a
Type: IccXML/libIccXML2-static.a: current ar archive
Deps:
    IccXML/libIccXML2-static.a(IccIoXml.cpp.o):
    IccXML/libIccXML2-static.a(IccMpeXml.cpp.o):
    IccXML/libIccXML2-static.a(IccMpeXmlFactory.cpp.o):
    IccXML/libIccXML2-static.a(IccProfileXml.cpp.o):
    IccXML/libIccXML2-static.a(IccTagXml.cpp.o):
    IccXML/libIccXML2-static.a(IccTagXmlFactory.cpp.o):
    IccXML/libIccXML2-static.a(IccUtilXml.cpp.o):

File: Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
Type: Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm
Type: Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles
Type: Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/local/opt/libtiff/lib/libtiff.6.dylib (compatibility version 8.0.0, current version 8.0.0)
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccTiffDump/iccTiffDump
Type: Tools/IccTiffDump/iccTiffDump: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/local/opt/libtiff/lib/libtiff.6.dylib (compatibility version 8.0.0, current version 8.0.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccFromXml/iccFromXml
Type: Tools/IccFromXml/iccFromXml: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccRoundTrip/iccRoundTrip
Type: Tools/IccRoundTrip/iccRoundTrip: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccSpecSepToTiff/iccSpecSepToTiff
Type: Tools/IccSpecSepToTiff/iccSpecSepToTiff: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/local/opt/libtiff/lib/libtiff.6.dylib (compatibility version 8.0.0, current version 8.0.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccToXml/iccToXml
Type: Tools/IccToXml/iccToXml: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccFromCube/iccFromCube
Type: Tools/IccFromCube/iccFromCube: Mach-O 64-bit executable x86_64
Deps:
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

xss@mini:~/tmp/dec6/PatchIccMAX/Build [0] [2024-12-06 19:12:54] $ cat file_with_deps.txt | sort | uniq
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.101.0)
        /usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
        /usr/local/opt/libtiff/lib/libtiff.6.dylib (compatibility version 8.0.0, current version 8.0.0)
        @rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
        @rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
File: IccProfLib/libIccProfLib2-static.a
File: IccProfLib/libIccProfLib2.2.1.25.dylib
File: IccXML/libIccXML2-static.a
File: IccXML/libIccXML2.2.1.25.dylib
File: Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm
File: Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles
File: Tools/IccFromCube/iccFromCube
File: Tools/IccFromXml/iccFromXml
File: Tools/IccRoundTrip/iccRoundTrip
File: Tools/IccSpecSepToTiff/iccSpecSepToTiff
File: Tools/IccTiffDump/iccTiffDump
File: Tools/IccToXml/iccToXml
File: Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
IccProfLib/libIccProfLib2-static.a: current ar archive
IccProfLib/libIccProfLib2.2.1.25.dylib:
IccProfLib/libIccProfLib2.2.1.25.dylib: Mach-O 64-bit dynamically linked shared library x86_64
IccXML/libIccXML2-static.a: current ar archive
IccXML/libIccXML2.2.1.25.dylib:
IccXML/libIccXML2.2.1.25.dylib: Mach-O 64-bit dynamically linked shared library x86_64
Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm:
Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm: Mach-O 64-bit executable x86_64
Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles:
Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles: Mach-O 64-bit executable x86_64
Tools/IccFromCube/iccFromCube:
Tools/IccFromCube/iccFromCube: Mach-O 64-bit executable x86_64
Tools/IccFromXml/iccFromXml:
Tools/IccFromXml/iccFromXml: Mach-O 64-bit executable x86_64
Tools/IccRoundTrip/iccRoundTrip:
Tools/IccRoundTrip/iccRoundTrip: Mach-O 64-bit executable x86_64
Tools/IccSpecSepToTiff/iccSpecSepToTiff:
Tools/IccSpecSepToTiff/iccSpecSepToTiff: Mach-O 64-bit executable x86_64
Tools/IccTiffDump/iccTiffDump:
Tools/IccTiffDump/iccTiffDump: Mach-O 64-bit executable x86_64
Tools/IccToXml/iccToXml:
Tools/IccToXml/iccToXml: Mach-O 64-bit executable x86_64
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp:
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp: Mach-O 64-bit executable x86_64
```

### Unix

```
find Tools -type f -executable -exec sh -c 'file "$1" | grep -q "ELF.*executable" && { ldd "$1" 2>/dev/null | grep "not found" && echo "Executable: $1"; }' _ {} \;
find . -type f  -executable |xargs -I{} ldd {}

        linux-vdso.so.1 (0x00007fff64167000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f5c82681000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f5c828ba000)
        linux-vdso.so.1 (0x00007ffd49468000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f7811912000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f781182b000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f781180b000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f78115e2000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f7811b4e000)
        linux-vdso.so.1 (0x00007fff2c9e9000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f9ac7321000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f9ac755a000)
        linux-vdso.so.1 (0x00007ffde43b4000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f87f868e000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f87f85a7000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f87f8587000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f87f835e000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f87f88ca000)
        linux-vdso.so.1 (0x00007ffe6c93d000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007f9e8f15e000)
        libtiff.so.5 => /lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f9e8f0cd000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f9e8eea1000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f9e8edba000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f9e8ed98000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f9e8eb6f000)
        libwebp.so.7 => /lib/x86_64-linux-gnu/libwebp.so.7 (0x00007f9e8eb02000)
        libzstd.so.1 => /lib/x86_64-linux-gnu/libzstd.so.1 (0x00007f9e8ea33000)
        liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f9e8ea08000)
        libjbig.so.0 => /lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f9e8e9f7000)
        libjpeg.so.8 => /lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f9e8e976000)
        libdeflate.so.0 => /lib/x86_64-linux-gnu/libdeflate.so.0 (0x00007f9e8e950000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f9e8e934000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f9e8f2b8000)
        linux-vdso.so.1 (0x00007ffe62935000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007fc8644e1000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fc8642ac000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fc8641c5000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fc8641a5000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fc863f7a000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fc86463a000)
        linux-vdso.so.1 (0x00007ffd6f213000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007f5a318ca000)
        libtiff.so.5 => /lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f5a31839000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f5a3160d000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f5a31526000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f5a31504000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f5a312db000)
        libwebp.so.7 => /lib/x86_64-linux-gnu/libwebp.so.7 (0x00007f5a3126e000)
        libzstd.so.1 => /lib/x86_64-linux-gnu/libzstd.so.1 (0x00007f5a3119f000)
        liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f5a31174000)
        libjbig.so.0 => /lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f5a31163000)
        libjpeg.so.8 => /lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f5a310e2000)
        libdeflate.so.0 => /lib/x86_64-linux-gnu/libdeflate.so.0 (0x00007f5a310bc000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f5a310a0000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f5a31a23000)
        linux-vdso.so.1 (0x00007ffee3380000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007fc3b798b000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fc3b7756000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fc3b766f000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fc3b764f000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fc3b7424000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fc3b7ae2000)
        linux-vdso.so.1 (0x00007ffe13dd9000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007f459c2fa000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f459c0c5000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f459bfde000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f459bfbe000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f459bd93000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f459c453000)
        linux-vdso.so.1 (0x00007ffe8cf9f000)
        libIccXML2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/Release/libIccXML2.so.2 (0x00007f94275e3000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007f9427493000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f942725e000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f9427177000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f9427155000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f9426f2c000)
        libxml2.so.2 => /lib/x86_64-linux-gnu/libxml2.so.2 (0x00007f9426d4a000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f94276e0000)
        libicuuc.so.70 => /lib/x86_64-linux-gnu/libicuuc.so.70 (0x00007f9426b4f000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f9426b33000)
        liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f9426b06000)
        libicudata.so.70 => /lib/x86_64-linux-gnu/libicudata.so.70 (0x00007f9424ee8000)
        linux-vdso.so.1 (0x00007ffefb948000)
        libIccXML2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/Release/libIccXML2.so.2 (0x00007f6047d2a000)
        libtiff.so.5 => /lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f6047c99000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007f6047b49000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f604791d000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f6047834000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f6047814000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f60475eb000)
        libxml2.so.2 => /lib/x86_64-linux-gnu/libxml2.so.2 (0x00007f6047409000)
        libwebp.so.7 => /lib/x86_64-linux-gnu/libwebp.so.7 (0x00007f604739c000)
        libzstd.so.1 => /lib/x86_64-linux-gnu/libzstd.so.1 (0x00007f60472cd000)
        liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f60472a0000)
        libjbig.so.0 => /lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f604728f000)
        libjpeg.so.8 => /lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f604720e000)
        libdeflate.so.0 => /lib/x86_64-linux-gnu/libdeflate.so.0 (0x00007f60471ea000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f60471ce000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f6047e26000)
        libicuuc.so.70 => /lib/x86_64-linux-gnu/libicuuc.so.70 (0x00007f6046fd1000)
        libicudata.so.70 => /lib/x86_64-linux-gnu/libicudata.so.70 (0x00007f60453b3000)
        linux-vdso.so.1 (0x00007ffde85e3000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fc38d681000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fc38d59a000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fc38d57a000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fc38d351000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fc38da08000)
        linux-vdso.so.1 (0x00007ffced8da000)
        libIccProfLib2.so.2 => /home/xss/tmp/112/PatchIccMAX/Build/IccProfLib/libIccProfLib2.so.2 (0x00007fb59ec61000)
        libxml2.so.2 => /lib/x86_64-linux-gnu/libxml2.so.2 (0x00007fb59ea76000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fb59e84a000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fb59e763000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fb59e741000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fb59e518000)
        libicuuc.so.70 => /lib/x86_64-linux-gnu/libicuuc.so.70 (0x00007fb59e31d000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007fb59e301000)
        liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007fb59e2d6000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fb59ee73000)
        libicudata.so.70 => /lib/x86_64-linux-gnu/libicudata.so.70 (0x00007fb59c6b8000)
        not a dynamic executable
        not a dynamic executable
```
