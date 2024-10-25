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

### Windows Prerequisites

Ensure that you have the following tools installed on your Windows system:

- [Git for Windows](https://gitforwindows.org/)
- [Visual Studio 2022 Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)
- [vcpkg](https://github.com/microsoft/vcpkg)

***Note** As of 26-September-2024 there is a ***temporary*** [Visual Studio Project](https://xsscx.visualstudio.com/PatchIccMAX) available for aid in Collaboration, Development & Reproduction.

----
## Installing the RefIccMAX CMM on Windows

To install the RefIccMAX CMM on Windows, follow these simplified steps:

### Create the Installation Directory
In `C:\Program Files`, create a new directory called `RefIccMAX`. Then, copy the `RefIccMAXCmm.dll` file into the directory `C:\Program Files\RefIccMAX`.

### Update the Windows Registry
Instead of manually editing the registry, you can use a `.reg` file to automate the process.

#### Instructions:
- Create a new text file and paste the following content:

```
  Windows Registry Editor Version 5.00

  [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ICMatchers]
  "SICC"="C:\\Program Files\\RefIccMAX\\RefIccMAXCmm.dll"
```
- Save this file with a `.reg` extension, such as `Install-RefIccMAX.reg`.
- Double-click the `.reg` file to apply the registry settings.
- When prompted, confirm that you want to add the information to the registry.

### Verify the Installation
- Open the Registry Editor (`regedit`) by typing `regedit` in the Start > Run dialog.
- Navigate to `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ICMatchers`.
- Ensure that the `SICC` string value is present and points to `C:\Program Files\RefIccMAX\RefIccMAXCmm.dll`.

### Notes:
- **Elevated Prompt**: If you find an elevated powershell command prompt is necessary to perform the Automated Build on Windows using Visual Studio 2022 Community, copy and paste the following into your terminal:

   ```
   Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "iex (iwr -UseBasicParsing -Uri ''https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_revert_master_branch.ps1'').Content"' -Verb RunAs
   ```

- **Registry Backup**: Although using a `.reg` file is a straightforward process, it's always good practice to back up the registry before making changes. For more information on how to back up and restore the registry, refer to the Windows documentation.
- **Custom Installation Path**: If you install the `RefIccMAXCmm.dll` in a different directory, ensure you update the `.reg` file to reflect the correct path.

This method simplifies the installation process and reduces the potential for manual errors when updating the registry.

## Subdirectories and Files in contrib/

### [Workflows](contrib/.github/workflows)
This directory contains GitHub Actions workflow files used for continuous integration (CI) and code scanning.

- **codeql.yml**: A GitHub Actions workflow for CodeQL code scanning, which helps identify vulnerabilities and errors in the code.
- **macos-self-hosted-example.yml**: An example workflow for building the project using a self-hosted macOS runner.
- **windows-vs2022-vcpkg-example.yml**: An example workflow for building the project on Windows using Visual Studio 2022 and vcpkg.

### [CalcTest](contrib/CalcTest)
The `CalcTest` directory includes shell scripts for performing various calculations and profile checks.

- **calc_test.zsh**: A script for running a set of calculation tests.
- **check_profiles.zsh**: A script for verifying ICC profile compatibility and integrity.
- **test_icc_apply_named_cmm.zsh**: A script for testing the application of named Color Management Modules (CMM) to ICC profiles.

### [Doxygen](contrib/Doxygen)
The `Doxygen` directory contains configuration files for generating project documentation using Doxygen.

- **Doxyfile**: The main configuration file for Doxygen, specifying how the documentation should be generated.
- **README.md**: A readme file providing an overview of how to use Doxygen for generating documentation.

### [HelperScripts](contrib/HelperScripts)
The `HelperScripts` directory contains various helper scripts for building dependencies and running tests.

- **libtiff_build.zsh**: A script for building the libtiff library, which is a dependency for the project.
- **libxml2_build.zsh**: A script for building the libxml2 library, another dependency for the project.
- **test_xmlarray_type.zsh**: A script for testing XML array types.
- **vs2022_build.ps1**: A PowerShell script for building the project using Visual Studio 2022.

### [UnitTest](contrib/UnitTest)
The `UnitTest` directory includes unit test files and related scripts.

- **cve-2023-46602-icFixXml-function-IccTagXml_cpp-line_337-baseline-variant-000.xml**: An XML file related to testing a specific CVE (Common Vulnerabilities and Exposures) issue.
- **cve-2023-46602.icc**: An ICC profile file related to the same CVE issue.
- **cve-2023-46602.zsh**: A shell script for testing the specific CVE issue.
- **TestCIccTagXmlProfileSequenceId.cpp**: A C++ test file for the `CIccTagXmlProfileSequenceId` class.
- **TestParseText.cpp**: A C++ test file for testing text parsing functionality.
