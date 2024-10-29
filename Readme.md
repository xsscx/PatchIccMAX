# PatchIccMAX [Development Branch](https://github.com/xsscx/PatchIccMAX/tree/development/)

Welcome to Hoyt's Development Branch of the DemoIccMAX Project where I focus on accuracy and precision to safely work with ICC Color Profiles because **Data** is ***Code***.  There are updated Build [Scripts](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/Build) and [Unit Tests](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/UnitTest).

The [Development Branch](https://github.com/xsscx/PatchIccMAX/tree/development/) provides updated documentation, additional scripts, and modernized build instructions to supplement the legacy documentation of the DemoIccMAX project. The contrib/ directory provides updated examples and verified instructions to ensure a smooth experience with modern build systems and environments.

### Build Status | Development Branch
| Build OS & Device Info           | Build   |  Install  | IDE | CLI |
| -------------------------------- | ------------- | ------------- | ------------- | ------------- |
| macOS 15 X86_64       | ✅          | ✅          |     ✅          |   ✅          |
| macOS 15 arm  | ✅          | ✅          | ✅  | ✅          |
| Ubuntu WSL   | ✅          | ✅          |    ✅     | ✅          |
| Windows 11  | ✅          | ✅          | ✅   | ✅          |


# Automated Builds

The Project can be cloned and built automatically. Copy the command below and Paste into your Terminal to start the Build.

## Build via CMake

***tl;dr***

   ```
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/cmake/build_master_branch.sh)"
   ```

### Manual Build

```
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev  Cmake
make -j$(nproc) 2>&1 | grep 'error:'
```

## MSBuild on Windows using VS2022 Community

***tl;dr***

   ```
   iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_revert_master_branch.ps1").Content
   ```
