# PatchIccMAX [XNU Branch](https://github.com/xsscx/PatchIccMAX/tree/xnu/)

Welcome to Hoyt's XNU Branch of the DemoIccMAX Project where I am Refactoring the Cmake Configurations.

** TESTING ONLY**

### Reproduction

```
export CXX=clang++
https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git checkout xnu
cd Build
brew install nlohmann-json libxml2 wxwidgets libtiff
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev Cmake/
make clean
make -j$(nproc)
```

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


# Automated Builds

The Project can be cloned and built automatically. Copy the command below and Paste into your Terminal to start the Build.

## Build Instructions

The Project code currently compiles on Unix & Windows out of the box using **Clang**, **MSVC** and **GNU** C++ with the instructions provided below.

### XNU **Clang** Build 

Copy and Paste into your Terminal:

```
export CXX=clang++
cd /tmp
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/xnu_build_master_branch.zsh)"
```

### Linux **Clang** Build

```
export CXX=clang++
cd /tmp
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/xnu_build_master_branch.zsh)"
```

### Expected Output

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

### Build with **GNU C++**

Manually complete the Clone, Patch & Build process shown below on Ubuntu:

```
#### Clone the DemoIccMAX repository
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX

# Clone the PatchIccMAX repository to a directory outside the DemoIccMAX repo
git clone https://github.com/xsscx/PatchIccMAX.git ../PatchIccMAX
cd ../PatchIccMAX
git checkout development
cd -

# Apply the GCC Patch from the PatchIccMAX repository
# TODO: Analyze Scoping Issue, Fix Template, Re: GNU C++ Strict Checks vs Clang
git apply ../PatchIccMAX/contrib/patches/pr109-ubuntu-5.15.153.1-microsoft-standard-WSL2-patch.txt

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
Darwin Kernel Version 24.1.0: Thu Oct 10 21:02:27 PDT 2024; root:xnu-11215.41.3~2/RELEASE_X86_64 x86_64
24.1.0 Darwin Kernel Version 24.1.0: Thu Oct 10 21:05:14 PDT 2024; root:xnu-11215.41.3~2/RELEASE_ARM64_T8103 arm64
5.15.153.1-microsoft-standard-WSL2 #1 SMP Fri Mar 29 23:14:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
Microsoft Windows 11 Pro 10.0.26100 26100 & VisualStudio/17.12.1
```

Summary: Patch for GNU C++ in process.

### Other Example

## MSBuild on Windows using VS2022 Community

***tl;dr***

   ```
   iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_revert_master_branch.ps1").Content
   ```

## Build via CMake

***tl;dr***

   ```
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/cmake/build_master_branch.sh)"
   ```

### Manual Build Examples

**Unix**
```
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev  Cmake
make -j$(nproc) 2>&1 | grep 'error:'
```

**Windows**

*Visual Studio*

```
cmake -S ..\Cmake\ -B d -G "Visual Studio 17 2022"  -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=F:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MDd /I F:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MDd /I F:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:F:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DCMAKE_CXX_FLAGS="-fno-implicit-templates -fvisibility=hidden" -DCMAKE_C_FLAGS="-fno-implicit-templates -fvisibility=hidden" -DCMAKE_BUILD_TYPE=Release -Wno-dev --log-level=DEBUG
cmake --build d --config Release
```

*ninja*

```
cmake -S ..\..\Cmake\ -B d -G "Ninja"  -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=F:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS="/MDd /I F:/test/vcpkg/installed/x64-windows/include" -DCMAKE_CXX_FLAGS="/MDd /I F:/test/vcpkg/installed/x64-windows/include" -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:F:/test/vcpkg/installed/x64-windows/lib" -DENABLE_TOOLS=ON -DCMAKE_CXX_FLAGS="-fno-implicit-templates -fvisibility=hidden" -DCMAKE_C_FLAGS="-fno-implicit-templates -fvisibility=hidden" -DCMAKE_BUILD_TYPE=Release -Wno-dev --log-level=DEBUG
cmake --build d --config Release
```

*vcpkg*

```
cmake -S ..\Cmake\ -B build -G "Visual Studio 17 2022" -T "v143"-A x64 -DCMAKE_TOOLCHAIN_FILE=F:/test/vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build d --config Release
```
