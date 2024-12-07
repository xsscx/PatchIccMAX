# XNU Build for Xcode Project using Cmake | DemoIccMAX Project

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
```

## Expected Output

```
Sat Dec  7 14:45:00 EST 2024: Starting binary analysis for ./Tools, ./IccXML, and ./IccProfLib
Sat Dec  7 14:45:00 EST 2024:
Sat Dec  7 14:45:00 EST 2024: Summary Report
Sat Dec  7 14:45:01 EST 2024: --------------
Sat Dec  7 14:45:01 EST 2024: Total Files Found: 15
Sat Dec  7 14:45:01 EST 2024: Executables Found: 11
Sat Dec  7 14:45:01 EST 2024: Dynamic Libraries Found: 2
Sat Dec  7 14:45:01 EST 2024: Static Libraries Found: 2
Sat Dec  7 14:45:01 EST 2024: List of Executables:
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccV5DspObsToV4Dsp/Release/iccV5DspObsToV4Dsp
Sat Dec  7 14:45:01 EST 2024:   ./Tools/CmdLine/IccApplyNamedCmm_Build/Release/iccApplyNamedCmm
Sat Dec  7 14:45:01 EST 2024:   ./Tools/CmdLine/IccApplyProfiles_Build/Release/iccApplyProfiles
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccTiffDump/Release/iccTiffDump
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccFromXml/Release/iccFromXml
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccRoundTrip/Release/iccRoundTrip
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccSpecSepToTiff/Release/iccSpecSepToTiff
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccToXml/Release/iccToXml
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccFromCube/Release/iccFromCube
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccApplyToLink/Release/iccApplyToLink
Sat Dec  7 14:45:01 EST 2024:   ./Tools/IccDumpProfile/Release/iccDumpProfile
Sat Dec  7 14:45:01 EST 2024: List of Dynamic Libraries:
Sat Dec  7 14:45:01 EST 2024:   ./IccXML/Release/libIccXML2.2.1.25.dylib
Sat Dec  7 14:45:01 EST 2024:   ./IccProfLib/Release/libIccProfLib2.2.1.25.dylib
Sat Dec  7 14:45:01 EST 2024: List of Static Libraries:
Sat Dec  7 14:45:01 EST 2024:   ./IccXML/Release/libIccXML2-static.a
Sat Dec  7 14:45:01 EST 2024:   ./IccProfLib/Release/libIccProfLib2-static.a
Sat Dec  7 14:45:01 EST 2024: Binary analysis completed. Logs written to binary_summary_20241207_144500.log.
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
