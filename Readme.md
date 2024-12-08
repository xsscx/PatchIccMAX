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
## Linux: sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential || { echo "Error: Failed to install dependencies. Exiting."; exit 1; } || { echo "Error: Failed to install dependencies. Exiting."; exit 1; }
## Windows integrated: Use vcpkg.json
## Windows classic: .\vcpkg.exe install nlohmann-json:x64-windows nlohmann-json:x64-windows-static libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static
##
##
#
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev Cmake/
make clean
make -j$(nproc)
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)" || { echo "Error: Profile creation failed. Exiting."; exit 1; }
```

### Configure & Build Status for *Windows & UNIX*

---

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

## Windows | Cmake Configure

```
cmake -S ..\CMake\ -B o  -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=F:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MD /I F:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MD /I F:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:F:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON  -DENABLE_SHARED_LIBS=ON
```

## Windows | Expected Output

```
-- ##########################################################################
-- ## Starting config in Build/Cmake/CMakeLists.txt at 2024-12-06 12:38:24
--
-- The C compiler identification is MSVC 19.42.34435.0
-- The CXX compiler identification is MSVC 19.42.34435.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/Tools/MSVC/14.42.34433/bin/Hostx64/x64/cl.exe - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/Tools/MSVC/14.42.34433/bin/Hostx64/x64/cl.exe - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Set PROJECT_UP_NAME to 'REFICCMAX'.
-- Set CMAKE_CXX_STANDARD to 17.
-- REFICCMAX_MAJOR_VERSION set to 2
-- REFICCMAX_MINOR_VERSION set to 1
-- REFICCMAX_MICRO_VERSION set to 25
-- REFICCMAX_VERSION PROJECT_UP_NAME set to 2.1.25
-- reficcmax PROJECT_DOWN_NAME Version set to 2.1.25
-- Build Configurations: Debug;Release;MinSizeRel;RelWithDebInfo
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake/../..
--
-- CI/CD Integration: Not Detected
--
-- ### System Information ###
-- CMAKE_SOURCE_DIR: F:/dec52-color/PatchIccMAX/Build/Cmake
-- PROJECT_ROOT_DIR is resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake/../..
-- System Name: Windows
-- System Version: 10.0.26100
-- System Processor: AMD64
-- Build Host: DESKTOP-3L2MB6E (h0233)
--
-- ### Environment Details ###
-- Path Separator:
-- PATH Environment Variable (63 entries):
-- [0] C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.42.34433\bin\HostX64\x64
-- ### PATH Environment Variable ###
-- [0] C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.42.34433\bin\HostX64\x64
--
-- ### CMAKE_ Details ###
-- CMAKE_PREFIX_PATH: F:/test/vcpkg/installed/x64-windows;F:/test/vcpkg/installed/x64-windows/debug
-- CMAKE_INSTALL_PREFIX: C:/Program Files/RefIccMAX
-- CMAKE_MODULE_PATH:
--
-- ### Compiler Information ###
-- C++ Compiler: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/Tools/MSVC/14.42.34433/bin/Hostx64/x64/cl.exe
-- C++ Compiler ID: MSVC
-- C++ Compiler Version: 19.42.34435.0
-- C Compiler: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/Tools/MSVC/14.42.34433/bin/Hostx64/x64/cl.exe
-- C Compiler Version: 19.42.34435.0
-- Linker: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/Tools/MSVC/14.42.34433/bin/Hostx64/x64/link.exe
--
-- ## Logging Config ##
-- Logging is enabled
--
-- ## Logging Debug Config ##
-- Debug logging is enabled
--
-- ## Platform-Specific Flags ##
-- ### Windows Specific Details ###
-- Windows SDK Version: 10.0.26100.0
-- MSBuild found at: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/MSBuild/Current/Bin/amd64/MSBuild.exe
-- Using Vcpkg toolchain file: F:/test/vcpkg/scripts/buildsystems/vcpkg.cmake
--
-- ### Cross-Platform Debugging Details ###
-- Build Type: Release
-- Install Prefix: C:/Program Files/RefIccMAX
-- Build Generator: Visual Studio 17 2022
-- Build Tool: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/MSBuild/Current/Bin/amd64/MSBuild.exe
--
-- ### Build Configuration ###
-- C++ Standard: 17
-- C++ Flags: /MD /I F:/test/vcpkg/installed/x64-windows/include
-- C Flags: /MD /I F:/test/vcpkg/installed/x64-windows/include
-- Build Type & Flags (Release):
--
-- ### Feature Configuration ###
-- Enable Tools: ON
-- Enable Tests: OFF
-- Enable Shared Libraries: ON
-- Enable Static Libraries: OFF
--
-- ### Build Configuration ###
-- Build Type: Release
-- C++ Standard: 17
-- C++ Flags: /MD /I F:/test/vcpkg/installed/x64-windows/include
-- C Flags: /MD /I F:/test/vcpkg/installed/x64-windows/include
-- Build Type & Flags (Release):
--
-- ### Feature Configuration ###
-- Enable Tools: ON
-- Enable Tests: OFF
-- Enable Shared Libraries: ON
-- Enable Static Libraries: OFF
--
-- ### Dependencies ###
-- Found Iconv: F:/test/vcpkg/installed/x64-windows/lib/iconv.lib (found version "1.17")
-- Checking for LibXml2...
--   LibXml2 Library: debug;F:/test/vcpkg/installed/x64-windows/debug/lib/libxml2.lib;optimized;F:/test/vcpkg/installed/x64-windows/lib/libxml2.lib;F:/test/vcpkg/installed/x64-windows/lib/iconv.lib;F:/test/vcpkg/installed/x64-windows/lib/charset.lib
--   LibXml2 Include Directory: F:/test/vcpkg/installed/x64-windows/include/libxml2
--   LibXml2 Version:
--
-- Checking for nlohmann_json...
-- Found nlohmann_json: F:/test/vcpkg/installed/x64-windows/share/nlohmann_json/nlohmann_jsonConfig.cmake (found version "3.11.3")
--   nlohmann_json Directory: F:/test/vcpkg/installed/x64-windows/share/nlohmann_json
--   nlohmann_json Version: 3.11.3
--
-- Checking for TIFF...
-- Found TIFF: optimized;F:/test/vcpkg/installed/x64-windows/lib/tiff.lib;debug;F:/test/vcpkg/installed/x64-windows/debug/lib/tiffd.lib (found version "4.7.0")
--   TIFF Library: optimized;F:/test/vcpkg/installed/x64-windows/lib/tiff.lib;debug;F:/test/vcpkg/installed/x64-windows/debug/lib/tiffd.lib
--   TIFF Include Directory: F:/test/vcpkg/installed/x64-windows/include
--   TIFF Version:
--
-- ### Include Directories ###
--   IccProfLib: F:/dec52-color/PatchIccMAX/Build/Cmake/../../IccProfLib
--   IccXML: F:/dec52-color/PatchIccMAX/Build/Cmake/../../IccXML
--
-- ### Link Directories ###
--   IccProfLib: F:/dec52-color/PatchIccMAX/Build/win/o/IccProfLib
--   IccXML: F:/dec52-color/PatchIccMAX/Build/win/o/IccXML
--   /usr/local/lib
--
-- ### Library Paths ###
--   Library Path for IccProfLib: F:/dec52-color/PatchIccMAX/Build/Cmake/../../Build/IccProfLib
--   Library Path for IccXML: F:/dec52-color/PatchIccMAX/Build/Cmake/../../Build/IccXML
--
-- ## Starting GNUInstallDirs ##
--
-- Enforcing Build Type
--
-- Setting Compiler Flags
-- ### Windows Specific Details ###
-- Windows SDK Version: 10.0.26100.0
-- ProgramFiles(x86): C:\Program Files (x86)
-- MSBuild found at: C:/Program Files/Microsoft Visual Studio/2022/Enterprise/MSBuild/Current/Bin/amd64/MSBuild.exe
-- Configuring MSVC runtime and flags
-- Adding subdirectory for IccProfLib.
-- #######################################################################
-- ## Configuring the IccProfLib2 in Build/Cmake/IccProfLib/CMakelists.txt
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake/../..
-- CMAKE_SOURCE_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake
-- SRC_PATH resolved as: ../../..
-- Resolved source file paths:
--   ../../../IccProfLib/IccApplyBPC.cpp
--   ../../../IccProfLib/IccArrayBasic.cpp
--   ../../../IccProfLib/IccArrayFactory.cpp
--   ../../../IccProfLib/IccCAM.cpp
--   ../../../IccProfLib/IccCmm.cpp
--   ../../../IccProfLib/IccConvertUTF.cpp
--   ../../../IccProfLib/IccEncoding.cpp
--   ../../../IccProfLib/IccEnvVar.cpp
--   ../../../IccProfLib/IccEval.cpp
--   ../../../IccProfLib/IccIO.cpp
--   ../../../IccProfLib/IccMatrixMath.cpp
--   ../../../IccProfLib/IccMpeACS.cpp
--   ../../../IccProfLib/IccMpeBasic.cpp
--   ../../../IccProfLib/IccMpeCalc.cpp
--   ../../../IccProfLib/IccMpeFactory.cpp
--   ../../../IccProfLib/IccMpeSpectral.cpp
--   ../../../IccProfLib/IccPrmg.cpp
--   ../../../IccProfLib/IccPcc.cpp
--   ../../../IccProfLib/IccProfile.cpp
--   ../../../IccProfLib/IccSolve.cpp
--   ../../../IccProfLib/IccSparseMatrix.cpp
--   ../../../IccProfLib/IccStructBasic.cpp
--   ../../../IccProfLib/IccStructFactory.cpp
--   ../../../IccProfLib/IccTagBasic.cpp
--   ../../../IccProfLib/IccTagComposite.cpp
--   ../../../IccProfLib/IccTagDict.cpp
--   ../../../IccProfLib/IccTagEmbedIcc.cpp
--   ../../../IccProfLib/IccTagFactory.cpp
--   ../../../IccProfLib/IccTagLut.cpp
--   ../../../IccProfLib/IccTagMPE.cpp
--   ../../../IccProfLib/IccTagProfSeqId.cpp
--   ../../../IccProfLib/IccUtil.cpp
--   ../../../IccProfLib/IccXformFactory.cpp
--   ../../../IccProfLib/IccMD5.cpp
-- Added executable target: IccProfLib2
-- Using explicit absolute path for ICCPROFLIB_PATH:
-- Added linker options for library path.
-- ## Exiting the IccProfLib2 Project in Build/Cmake/IccProfLib/CMakelists.txt
-- ###########################################################################
-- Adding subdirectory for IccXML.
-- ##########################################################################
-- ## Entering the IccXML2 Project in Build/Cmake/IccXML/CMakelists.txt
-- Project root resolved as F:/dec52-color/PatchIccMAX/Build/Cmake/../..
-- Resolved C file paths:
--   ../../../IccXML/IccLibXML/IccIoXml.cpp
--   ../../../IccXML/IccLibXML/IccMpeXml.cpp
--   ../../../IccXML/IccLibXML/IccMpeXmlFactory.cpp
--   ../../../IccXML/IccLibXML/IccProfileXml.cpp
--   ../../../IccXML/IccLibXML/IccTagXml.cpp
--   ../../../IccXML/IccLibXML/IccTagXmlFactory.cpp
--   ../../../IccXML/IccLibXML/IccUtilXml.cpp
-- Include directories:
--   - ../../../IccProfLib
--   - ../../../IccXML/IccLibXML
--   - C:/libxml2/libxml2-2.8.0/include
--   - C:/iconv/iconv-1.9.2/include
-- Linking against libraries:
--   debug
--   F:/test/vcpkg/installed/x64-windows/debug/lib/libxml2.lib
--   optimized
--   F:/test/vcpkg/installed/x64-windows/lib/libxml2.lib
--   F:/test/vcpkg/installed/x64-windows/lib/iconv.lib
--   F:/test/vcpkg/installed/x64-windows/lib/charset.lib
-- Added shared library target: IccXML2
-- Resolved Project Root Directory:
--   F:/dec52-color/PatchIccMAX/Build/Cmake/../..
-- Resolved CMake Source Directory:
--   F:/dec52-color/PatchIccMAX/Build/Cmake
-- Resolved Source Path:
--   ../../..
-- Added Target:
--   IccXML2
-- Using Extra Libraries:
--   No extra libraries specified.
-- Using .def File for Symbol Exports:
--   No .def file specified.
-- ## Exiting the IccXML2 Project in Build/Cmake/IccXML/CMakelists.txt
-- ##########################################################################
-- LibXml2 Library: debug;F:/test/vcpkg/installed/x64-windows/debug/lib/libxml2.lib;optimized;F:/test/vcpkg/installed/x64-windows/lib/libxml2.lib
-- LibXml2 Include Directory: F:/test/vcpkg/installed/x64-windows/include/libxml2
-- nlohmann_json library found: F:/test/vcpkg/installed/x64-windows/share/nlohmann_json
-- Found nlohmann JSON library at: F:/test/vcpkg/installed/x64-windows/share/nlohmann_json
-- Adding IccApplyNamedCmm from: F:/dec52-color/PatchIccMAX/Build/Cmake/../../Tools/CmdLine/IccApplyNamedCmm
-- Added IccApplyNamedCmm
-- Adding IccApplyProfiles from: F:/dec52-color/PatchIccMAX/Build/Cmake/../../Tools/CmdLine/IccApplyProfiles
-- TIFF include directory: F:/test/vcpkg/installed/x64-windows/include
-- TIFF libraries: optimized;F:/test/vcpkg/installed/x64-windows/lib/tiff.lib;debug;F:/test/vcpkg/installed/x64-windows/debug/lib/tiffd.lib
-- nlohmann_json library found: F:/test/vcpkg/installed/x64-windows/share/nlohmann_json
-- Added IccApplyProfiles
-- Adding Subdirectory: Tools/IccDumpProfile...
-- #############################################################################################
-- Entering IccDumpProfile in Project_Root/Build/Cmake/Tools/IccDumpProfile/CMakeLists.txt .....
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- CMAKE_SOURCE_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake
-- Defining target 'IccDumpProfile'...
-- Source file resolved as: F:/dec52-color/PatchIccMAX/Tools/CmdLine/IccDumpProfile/IccDumpProfile.cpp
-- Added executable target: IccDumpProfile
-- Added include directories for IccDumpProfile
-- Compiler options set for IccDumpProfile
-- Linker options set for IccDumpProfile
-- Linked libraries for IccDumpProfile
-- Output directories set for IccDumpProfile
-- Added post-build step for IccDumpProfile
-- Installation enabled. 'IccDumpProfile' will be installed to bin.
-- CMAKE_SOURCE_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- Exiting IccDumpProfile in Project_Root/Build/Cmake/Tools/IccDumpProfile/CMakeLists.txt
-- ######################################################################################
-- Successfully added Subdirectory: Tools/IccDumpProfile
-- Adding Subdirectory: Tools/IccRoundTrip...
-- Successfully added Subdirectory: Tools/IccRoundTrip
-- Adding Subdirectory: Tools/IccFromCube...
-- Successfully added Subdirectory: Tools/IccFromCube
-- Adding Subdirectory: Tools/IccV5DspObsToV4Dsp...
-- Successfully added Subdirectory: Tools/IccV5DspObsToV4Dsp
-- Adding Subdirectory: Tools/IccApplyToLink...
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Entering IccApplyToLink in Project_Root/Build/Cmake/Tools/IccApplyToLink/CMakeLists.txt .....
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- CMAKE_SOURCE_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake
-- Defining target 'iccApplyToLink'...
-- SRC_PATH resolved as: F:/dec52-color/PatchIccMAX/Tools/CmdLine/IccApplyToLink
-- Resolved source file path: F:/dec52-color/PatchIccMAX/Tools/CmdLine/IccApplyToLink/IccApplyToLink.cpp
-- Source file found at: F:/dec52-color/PatchIccMAX/Tools/CmdLine/IccApplyToLink/IccApplyToLink.cpp
-- Added executable target: iccApplyToLink
-- Installation enabled. 'iccApplyToLink' will be installed to bin.
-- CMAKE_SOURCE_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- Exiting IccApplyToLink in Project_Root/Build/Cmake/Tools/IccApplyToLink/CMakeLists.txt ......
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Successfully added Subdirectory: Tools/IccApplyToLink
-- Checking for TIFF library...
-- TIFF library found:
--   TIFF Library: optimized;F:/test/vcpkg/installed/x64-windows/lib/tiff.lib;debug;F:/test/vcpkg/installed/x64-windows/debug/lib/tiffd.lib
--   TIFF Include Directory: F:/test/vcpkg/installed/x64-windows/include
-- Adding Subdirectory: Tools/IccSpecSepToTiff...
-- Successfully added Subdirectory: Tools/IccSpecSepToTiff
-- Adding Subdirectory: Tools/IccTiffDump...
-- Successfully added Subdirectory: Tools/IccTiffDump
-- TIFF Library: optimized;F:/test/vcpkg/installed/x64-windows/lib/tiff.lib;debug;F:/test/vcpkg/installed/x64-windows/debug/lib/tiffd.lib
-- TIFF Include Directory: F:/test/vcpkg/installed/x64-windows/include
-- nlohmann_json Directory: F:/test/vcpkg/installed/x64-windows/share/nlohmann_json
-- TIFF Library: optimized;F:/test/vcpkg/installed/x64-windows/lib/tiff.lib;debug;F:/test/vcpkg/installed/x64-windows/debug/lib/tiffd.lib
-- TIFF Include Directory: F:/test/vcpkg/installed/x64-windows/include
-- nlohmann_json Directory: F:/test/vcpkg/installed/x64-windows/share/nlohmann_json
-- Adding subdirectory: Tools/IccFromXml...
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Entering IccFromXml in Project_Root/Build/Cmake/Tools/IccFromXml/CMakeLists.txt .............
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- Source file resolved as: F:/dec52-color/PatchIccMAX/IccXML/CmdLine/IccFromXml/IccFromXml.cpp
-- Added executable target: iccFromXml
-- Include directories added for iccFromXml
-- Linker directories added for iccFromXml
-- Libraries linked for iccFromXml
-- Output directories set for iccFromXml
-- Added post-build step for iccFromXml
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- CMAKE_SOURCE_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake
-- SRC_PATH resolved as: F:/dec52-color/PatchIccMAX/IccXML/CmdLine/IccFromXml
-- Resolved source file path: F:/dec52-color/PatchIccMAX/IccXML/CmdLine/IccFromXml/IccFromXml.cpp
-- Added executable target: iccFromXml
-- Added linker options for library path.
-- Using explicit absolute path for ICCPROFLIB_PATH:
-- Added linker options for library path: F:/dec52-color/PatchIccMAX/Build/win/t/IccProfLib/Release
-- Using explicit absolute path for IccXML_LIB_DIR: F:/dec52-color/PatchIccMAX/Build/win/t/IccXML/Release
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exiting IccFromXml in Project_Root/Build/Cmake/Tools/IccFromXml/CMakeLists.txt ..............
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Successfully added subdirectory: Tools/IccFromXml
-- Configuring Tools/IccToXml...
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Entering IccToXml in Project_Root/Build/Cmake/Tools/IccToXml/CMakeLists.txt .............
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- Source file resolved as: F:/dec52-color/PatchIccMAX/IccXML/CmdLine/IccToXml/IccToXml.cpp
-- Added executable target: IccToXml
-- Include directories added for IccToXml
-- Linker directories added for IccToXml
-- Libraries linked for IccToXml
-- Output directories set for IccToXml
-- DEBUG 9: Added post-build step for IccToXml
-- PROJECT_ROOT_DIR resolved as: F:/dec52-color/PatchIccMAX
-- CMAKE_SOURCE_DIR resolved as: F:/dec52-color/PatchIccMAX/Build/Cmake
-- SRC_PATH resolved as: F:/dec52-color/PatchIccMAX/IccXML/CmdLine/IccToXml
-- Resolved source file path: F:/dec52-color/PatchIccMAX/IccXML/CmdLine/IccToXml/IccToXml.cpp
-- Added executable target: IccToXml
-- Added linker options for library path.
-- Using explicit absolute path for ICCPROFLIB_PATH:
-- Added linker options for library path: F:/dec52-color/PatchIccMAX/Build/win/t/IccProfLib/Release
-- Using explicit absolute path for IccXML_LIB_DIR: F:/dec52-color/PatchIccMAX/Build/win/t/IccXML/Release
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exiting IccToXml in Project_Root/Build/Cmake/Tools/IccToXml/CMakeLists.txt ..............
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Successfully added subdirectory: Tools/IccToXml
-- ### Configuring wxWidgets ###
-- Found wxWidgets: debug;F:/test/vcpkg/installed/x64-windows/debug/lib/wxmsw32ud_core.lib;optimized;F:/test/vcpkg/installed/x64-windows/lib/wxmsw32u_core.lib;debug;F:/test/vcpkg/installed/x64-windows/debug/lib/wxbase32ud.lib;optimized;F:/test/vcpkg/installed/x64-windows/lib/wxbase32u.lib;winmm;comctl32;uuid;oleacc;uxtheme;rpcrt4;shlwapi;version;wsock32 (found version "3.2.6") found components: core base missing components: png tiff jpeg zlib regex expat
-- wxWidgets successfully found and configured:
--   Include Directories:
--     F:/test/vcpkg/installed/x64-windows/lib/mswu
--     F:/test/vcpkg/installed/x64-windows/include
--   Libraries:
--     debug
--     F:/test/vcpkg/installed/x64-windows/debug/lib/wxmsw32ud_core.lib
--     optimized
--     F:/test/vcpkg/installed/x64-windows/lib/wxmsw32u_core.lib
--     debug
--     F:/test/vcpkg/installed/x64-windows/debug/lib/wxbase32ud.lib
--     optimized
--     F:/test/vcpkg/installed/x64-windows/lib/wxbase32u.lib
--     winmm
--     comctl32
--     uuid
--     oleacc
--     uxtheme
--     rpcrt4
--     shlwapi
--     version
--     wsock32
-- wxWidgets configuration completed successfully.
Configured RefIccMAX-Windows64-2.1.25
-- --------------------------------------------------------------------------
-- ## Exiting config in Build/Cmake/CMakeLists.txt at 2024-12-06 12:38:24
-- --------------------------------------------------------------------------
-- Configuring done (10.6s)
-- Generating done (0.3s)
-- Build files have been written to: F:/dec52-color/PatchIccMAX/Build/win/o
```

## Cmake Build Release | x64

```
[2024-12-06 12:38:36 Build\win]%  cmake --build o  --config Release -j32
```

## Vcpkg Build Status | Windows

100% Success

## Cmake Build Status | Windows

```
[2024-12-06 12:41:58 Build\win]%  cmake --build o  --config Release -j32
---
  IccProfLib2.vcxproj -> Build\win\o\IccProfLib\Release\IccProfLib2.dll
  iccRoundTrip.vcxproj -> Build\win\o\Tools\IccRoundTrip\Release\iccRoundTrip.exe
  iccV5DspObsToV4Dsp.vcxproj -> Build\win\o\Tools\IccV5DspObsToV4Dsp\Release\iccV5DspObsToV4Dsp.exe
  iccSpecSepToTiff.vcxproj -> Build\win\o\Tools\IccSpecSepToTiff\Release\iccSpecSepToTiff.exe
  iccFromCube.vcxproj -> Build\win\o\Tools\IccFromCube\Release\iccFromCube.exe
  iccTiffDump.vcxproj -> Build\win\o\Tools\IccTiffDump\Release\iccTiffDump.exe
  iccApplyToLink.vcxproj -> Testing\Release\iccApplyToLink.exe
  IccToXml.vcxproj -> Testing\Release\IccToXml.exe
  iccFromXml.vcxproj -> Testing\Release\iccFromXml.exe
  iccApplyNamedCmm.vcxproj -> Build\win\o\Tools\CmdLine\IccApplyNamedCmm_Build\Release\iccApplyNamedCmm.exe
  iccApplyProfiles.vcxproj -> Build\win\o\Tools\CmdLine\IccApplyProfiles_Build\Release\iccApplyProfiles.exe
---

Build Error in IccDumpProfile.vcxproj
---
Testing\Release\IccDumpProfile.exe : fatal error LNK1120: 2 unresolved externals [Build\win\o\Tools\IccDumpProfile\IccDumpProfile.vcxproj]

iccDumpProfile.obj : error LNK2019: unresolved external symbol "char const * const icMsgValidateWarning" (?icMsgValidateWarning@@3PEBDEB) referenced in function main [Buil
d\win\o\Tools\IccDumpProfile\IccDumpProfile.vcxproj]
iccDumpProfile.obj : error LNK2019: unresolved external symbol "char const * const icMsgValidateNonCompliant" (?icMsgValidateNonCompliant@@3PEBDEB) referenced in function main [F:\dec52-color\PatchI
ccMAX\Build\win\o\Tools\IccDumpProfile\IccDumpProfile.vcxproj]
```

## Cmake Build Summary | Refactored Configuration Q4/24

Cmake Build has **not** worked on Windows

| **Tool or Library**         | **Windows** | **macOS** | **Linux** | **WSL2** |
|-----------------------------|-------------|-----------|-----------|----------|
| iccApplyNamedCmm            | Yes         | Yes       |    Yes    |   Yes    |
| iccApplyProfiles            | Yes         | Yes       |    Yes    |   Yes    |
| iccApplyToLink              | Yes         | Yes       |    Yes    |   Yes    |
| iccDumpProfile              | Error       | Yes       |    Yes    |   Yes    |
| iccFromCube                 | Yes         | Yes       |    Yes    |   Yes    |
| iccFromXml                  | Yes         | Yes       |    Yes    |   Yes    |
| iccToXml                    | Yes         | Yes       |    Yes    |   Yes    |
| iccRoundTrip                | Yes         | Yes       |    Yes    |   Yes    |
| iccSpecSepToTiff            | Yes         | Yes       |    Yes    |   Yes    |
| iccTiffDump                 | Yes         | Yes       |    Yes    |   Yes    |
| IccV5DspObsToV4Dsp          | Yes         | Yes       |    Yes    |   Yes    |
| wxProfileDump               | Yes         | Yes       |    Yes    |   Yes    |
| libIccProfLib2              | Yes         | Yes       |    Yes    |   Yes    |
| libIccProfLib2_DLL          | Yes         | Yes       |    Yes    |   Yes    |
| libIccProfLib2_CRTDLL       | Yes         | Yes       |    Yes    |   Yes    |
| libIccXML2                  | Yes         | Yes       |    Yes    |   Yes    |
| libIccXML2_CRTDLL           | Yes         | Yes       |    Yes    |   Yes    |
| DemoIccMAXCmm               | Yes         | Yes       |    Yes    |   Yes    |

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
