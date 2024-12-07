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
