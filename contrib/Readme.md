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

   ```
  cd /tmp
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/cmake/build_master_branch.sh)"
   ```

### Manual Build

```
cd Build/
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev  Cmake
make -j$(nproc) 2>&1 | grep 'error:'
```

### Xcode Build

```
cd /tmp
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/master/contrib/Build/cmake/xnu_build_master_branch.zsh)"
```

## MSBuild on Windows using VS2022

   ```
   cd C:\temp\
   iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_revert_master_branch_release.ps1").Content
   ```

### Run Signed Files from Powershell

```
iwr -Uri "https://xss.cx/2024/10/26/signed/iccToXml.exe" -OutFile ".\iccToXml.exe"; & ".\iccToXml.exe" 
iwr -Uri "https://xss.cx/2024/10/26/signed/iccFromXml.exe" -OutFile ".\iccFromXml.exe"; & ".\iccFromXml.exe"  
iwr -Uri "https://xss.cx/2024/10/26/signed/iccDumpProfile.exe" -OutFile ".\iccDumpProfile.exe"; & ".\iccDumpProfile.exe" 
iwr -Uri "https://xss.cx/2024/10/26/signed/iccSpecSepToTiff.exe" -OutFile ".\iccSpecSepToTiff.exe"; & ".\iccSpecSepToTiff.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccApplyToLink.exe" -OutFile ".\iccApplyToLink.exe"; & ".\iccApplyToLink.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccApplyProfiles.exe" -OutFile ".\iccApplyProfiles.exe"; & ".\iccApplyProfiles.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccApplyNamedCmm.exe" -OutFile ".\iccApplynamedCmm.exe"; & ".\iccApplyNamedCmm.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccV5DspObsToV4Dsp.exe" -OutFile ".\iccV5DspObsToV4Dsp.exe"; & ".\iccV5DspObsToV4Dsp.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccRoundTrip.exe" -OutFile ".\iccRoundTrip.exe"; & ".\iccRoundTrip.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccFromCube.exe" -OutFile ".\iccFromCube.exe"; & ".\iccFromCube.exe"
```

## Click to Download Signed Tools
[iccToXml](https://xss.cx/2024/10/26/signed/iccToXml.exe)
[iccFromXml](https://xss.cx/2024/10/26/signed/iccFromXml.exe)
[iccDumpProfile](https://xss.cx/2024/10/26/signed/iccDumpProfile.exe)
[iccSpecSepToTiff](https://xss.cx/2024/10/26/signed/iccSpecSepToTiff.exe)
[iccApplyToLink](https://xss.cx/2024/10/26/signed/iccApplyToLink.exe)
[iccApplyProfiles](https://xss.cx/2024/10/26/signed/iccApplyProfiles.exe)
[iccApplyNamedCmm](https://xss.cx/2024/10/26/signed/iccApplyNamedCmm.exe)
[iccV5DspObsToV4Dsp](https://xss.cx/2024/10/26/signed/iccV5DspObsToV4Dsp.exe)
[iccRoundTrip](https://xss.cx/2024/10/26/signed/iccRoundTrip.exe)
[iccFromCube](https://xss.cx/2024/10/26/signed/iccFromCube.exe)

Note: iccTiffDump.exe has a memory leak and bails out

## Automatic Install of DemoIccMAXCmm.dll and Registry Key

Copy and Paste into Powershell:

```
mkdir "C:\Program Files\RefIccMAX"
cd "C:\Program Files\RefIccMAX"
iwr -Uri "https://xss.cx/2024/10/26/signed/DemoIccMAXCmm.dll" -OutFile ".\DemoIccMAXCmm.dll"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/HelperScripts/Install-RefIccMAX.reg" -OutFile "$env:TEMP\Install-RefIccMAX.reg"; Start-Process reg.exe -ArgumentList "import $env:TEMP\Install-RefIccMAX.reg" -Wait; Remove-Item "$env:TEMP\Install-RefIccMAX.reg" -Force
```

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
