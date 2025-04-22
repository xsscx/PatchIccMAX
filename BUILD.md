[![color.org logo](ReadMeFiles/ICC_header.png "color.org")](https://color.org)

# IccMAX Build

Install: `brew install iccmax`

### Dependencies
- `Cmake`: Required to build iccMAX
- `libxml2`: Required for XML support
- `libpng-dev`: Required for Png support
- `libjpeg-dev`: Required for Jpeg support
- `libjpeg-turbo`: Required for JPEG support
- `libwxgtk3.2-dev`: Required for GUI support
- `nlohmann-json3-dev`: Enables JSON parsing for configuration files
- `wxWidgets`: Cross-platform GUI framework for the basic profile viewer
- `libtiff`: Supports TIFF image manipulation for image processing tools

### Ubuntu GNU

```
export CXX=g++
cd ~
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/Build
sudo apt-get install -y libpng-dev libjpeg-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake Cmake
make -j$(nproc)
cd ..
```

### macOS Clang

```
export CXX=clang++
cd ~
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/Build
brew install libpng nlohmann-json libxml2 wxwidgets libtiff jpeg
cmake Cmake
make -j$(nproc)
cd ..
```

#### Xcode Project

```
cd Build/Xcode
cmake -G "Xcode"  ../Cmake
xcodebuild -project RefIccMAX.xcodeproj
cd ../../
```

---

### Windows MSVC

#### Prerequisites

- Windows 10/11
- Administrator Developer PowerShell or x64 Native Tools
- Visual Studio 2022 (C++ Desktop Development workload)

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
vcpkg integrate install
vcpkg install
cd Build
mkdir win
cd win
cmake ..\CMake -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_TOOLCHAIN_FILE="C:/Program Files/Microsoft Visual Studio/2022/Community/VC/vcpkg/scripts/buildsystems/vcpkg.cmake" `
  -DVCPKG_MANIFEST_DIR="../../"
cmake --build . -- /m /maxcpucount
```

---
