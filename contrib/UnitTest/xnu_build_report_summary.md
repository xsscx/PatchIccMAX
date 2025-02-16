# XNU Build for Xcode Project using Cmake | IccMAX Project

Last Updated: 16-FEB-2025 by David Hoyt | [@h02332](https://x.com/h02332)

The Zsh script summarizes Mach-O binaries, dynamically linked libraries (`.dylib`), and static libraries (`.a`) in the specified directories of the DemoIccMAX Project. The script generates a summary from logs execution results.

---

## Reproduction

```
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git checkout xnu
cd Build/XCode
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev ../Cmake/ -G "Xcode" -DCMAKE_VERBOSE_MAKEFILE=ON -Wdev -Werror=dev -DENABLE_STATIC_LIBS=ON -DCMAKE_VERBOSE_MAKEFILE=ON
xcodebuild -target ALL_BUILD -configuration "Release"
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/xnu/contrib/UnitTest/xnu_build_report_summary.zsh)" 
```

## Expected Output

```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/xnu/contrib/UnitTest/xnu_build_report_summary.zsh)"
Sun Feb 16 08:52:00 EST 2025: Starting binary analysis for ./Tools, ./IccXML, and ./IccProfLib
Sun Feb 16 08:52:01 EST 2025:
Sun Feb 16 08:52:01 EST 2025: Summary Report
Sun Feb 16 08:52:01 EST 2025: --------------
Sun Feb 16 08:52:01 EST 2025: Total Mach-O Files: 17
Sun Feb 16 08:52:01 EST 2025: Executables Found: 11
Sun Feb 16 08:52:01 EST 2025: Dynamic Libraries Found: 6
Sun Feb 16 08:52:01 EST 2025: Static Libraries Found: 0
Sun Feb 16 08:52:01 EST 2025: List of Executables:
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
Sun Feb 16 08:52:01 EST 2025:   ./Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm
Sun Feb 16 08:52:01 EST 2025:   ./Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccTiffDump/iccTiffDump
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccFromXml/iccFromXml
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccRoundTrip/iccRoundTrip
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccSpecSepToTiff/iccSpecSepToTiff
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccToXml/iccToXml
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccFromCube/iccFromCube
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccApplyToLink/iccApplyToLink
Sun Feb 16 08:52:01 EST 2025:   ./Tools/IccDumpProfile/iccDumpProfile
Sun Feb 16 08:52:01 EST 2025: List of Dynamic Libraries:
Sun Feb 16 08:52:01 EST 2025:   ./IccXML/libIccXML2.2.1.25.dylib
Sun Feb 16 08:52:01 EST 2025:   ./IccXML/libIccXML2.2.dylib
Sun Feb 16 08:52:01 EST 2025:   ./IccXML/libIccXML2.dylib
Sun Feb 16 08:52:01 EST 2025:   ./IccProfLib/libIccProfLib2.2.dylib
Sun Feb 16 08:52:01 EST 2025:   ./IccProfLib/libIccProfLib2.dylib
Sun Feb 16 08:52:01 EST 2025:   ./IccProfLib/libIccProfLib2.2.1.25.dylib
Sun Feb 16 08:52:01 EST 2025: Link List of Dynamic Libraries:
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
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: IccXML/libIccXML2.2.1.25.dylib
Type: IccXML/libIccXML2.2.1.25.dylib: Mach-O 64-bit dynamically linked shared library x86_64
Deps:
    	@rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
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
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm
Type: Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
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
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccTiffDump/iccTiffDump
Type: Tools/IccTiffDump/iccTiffDump: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/usr/local/opt/libtiff/lib/libtiff.6.dylib (compatibility version 8.0.0, current version 8.0.0)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccFromXml/iccFromXml
Type: Tools/IccFromXml/iccFromXml: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccRoundTrip/iccRoundTrip
Type: Tools/IccRoundTrip/iccRoundTrip: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccSpecSepToTiff/iccSpecSepToTiff
Type: Tools/IccSpecSepToTiff/iccSpecSepToTiff: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/usr/local/opt/libtiff/lib/libtiff.6.dylib (compatibility version 8.0.0, current version 8.0.0)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccToXml/iccToXml
Type: Tools/IccToXml/iccToXml: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccXML2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/usr/lib/libxml2.2.dylib (compatibility version 10.0.0, current version 10.9.0)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccFromCube/iccFromCube
Type: Tools/IccFromCube/iccFromCube: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccApplyToLink/iccApplyToLink
Type: Tools/IccApplyToLink/iccApplyToLink: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

File: Tools/IccDumpProfile/iccDumpProfile
Type: Tools/IccDumpProfile/iccDumpProfile: Mach-O 64-bit executable x86_64
Deps:
    	@rpath/libIccProfLib2.2.dylib (compatibility version 2.0.0, current version 2.1.25)
    	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 170.0.0)
    	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
    	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1800.105.0)
    	@rpath/libclang_rt.asan_osx_dynamic.dylib (compatibility version 0.0.0, current version 0.0.0)
    	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)

Sun Feb 16 08:52:01 EST 2025: Build Project, Profiles and Report. Logs written to binary_analysis_20250216_085200.log.
```

## File Details

```
find . -type f \( -path './bin-temp' -o -path './CMakeFiles' \) -prune -o -perm +111 -exec file {} \; | grep -i "Mach-O" | grep -vE './bin-temp|./CMakeFiles' | while read -r line; do echo "$line"; done

./Tools/IccV5DspObsToV4Dsp/Release/iccV5DspObsToV4Dsp: Mach-O 64-bit executable arm64
./Tools/CmdLine/IccApplyNamedCmm_Build/Release/iccApplyNamedCmm: Mach-O 64-bit executable arm64
./Tools/CmdLine/IccApplyProfiles_Build/Release/iccApplyProfiles: Mach-O 64-bit executable arm64
./Tools/IccTiffDump/Release/iccTiffDump: Mach-O 64-bit executable arm64
./Tools/IccFromXml/Release/iccFromXml: Mach-O 64-bit executable arm64
./Tools/IccRoundTrip/Release/iccRoundTrip: Mach-O 64-bit executable arm64
./Tools/IccSpecSepToTiff/Release/iccSpecSepToTiff: Mach-O 64-bit executable arm64
./Tools/IccToXml/Release/iccToXml: Mach-O 64-bit executable arm64
./Tools/IccFromCube/Release/iccFromCube: Mach-O 64-bit executable arm64
./Tools/IccApplyToLink/Release/iccApplyToLink: Mach-O 64-bit executable arm64
./Tools/IccDumpProfile/Release/iccDumpProfile: Mach-O 64-bit executable arm64
./IccXML/Release/libIccXML2.2.1.25.dylib: Mach-O 64-bit dynamically linked shared library arm64
./IccXML/Release/libIccXML2.2.dylib: Mach-O 64-bit dynamically linked shared library arm64
./IccXML/Release/libIccXML2.dylib: Mach-O 64-bit dynamically linked shared library arm64
./Testing/IccRoundTrip: Mach-O 64-bit executable x86_64
./Testing/IccDumpProfile: Mach-O 64-bit executable x86_64
./IccProfLib/Release/libIccProfLib2.2.dylib: Mach-O 64-bit dynamically linked shared library arm64
./IccProfLib/Release/libIccProfLib2.dylib: Mach-O 64-bit dynamically linked shared library arm64
./IccProfLib/Release/libIccProfLib2.2.1.25.dylib: Mach-O 64-bit dynamically linked shared library arm64
```
