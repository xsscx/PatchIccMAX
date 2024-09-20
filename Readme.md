
# Development Branch

Hello and Welcome to Hoyt's Development Branch of the DemoIccMAX Project.

The Development Branch provides updated documentation, additional scripts, and modernized build instructions to supplement the legacy documentation of the DemoIccMAX project. The contrib/ directory provides updated examples and verified instructions to ensure a smooth experience with modern build systems and environments.

## Building the Project with CMake on WSL Ubuntu

### Prerequisites

Before building the Development Branch on a WSL (Windows Subsystem for Linux) Ubuntu environment, ensure that the necessary libraries and tools are installed. Use the following command to install the required packages:

```
sudo apt-get install libwxgtk-media3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev \
libwxgtk3.0-gtk3-dev libwxgtk-media3.0-gtk3 libwxgtk-webview3.0-gtk3 \
libwxgtk3.0-gtk3 libxml2 libtiff5 libxml2-dev libtiff5-dev
```

### Clone the Project Repository

Next, clone the project repository from GitHub:

```
https://github.com/xsscx/PatchIccMAX.git
```

Change to the Development Branch directory:

```
cd PatchIccMAX
checkout development
```

### Configure the Build with CMake

Now, configure the build using CMake. The following command sets the installation prefix, build type, and compiler flags. The `-g` flag enables debugging information, `-fsanitize=address,undefined` enables address and undefined behavior sanitizers, and `-fno-omit-frame-pointer` ensures complete backtraces during debugging.

```
cd Build/
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
-Wno-dev Cmake/
```

### Build the Project

Finally, build the project using the `make` command. The `-j$(nproc)` flag parallelizes the build process based on the number of CPU cores available:

```
make -j$(nproc) 2>&1 | grep 'error:'
```

This command will compile the project and filter the output to display any errors that occur during the build process.

### Troubleshooting

- **Missing Dependencies:** If you encounter errors related to missing libraries, ensure that all required dependencies are installed as per the prerequisites.
- **Build Errors:** Review the output for any specific error messages and address them as needed. The use of sanitizers (`-fsanitize=address,undefined`) can help in identifying memory-related issues.


## CMake Build Instructions for macOS

### Overview

The Development Branch can be built on macOS using Xcode, with CMake as the preferred method for generating Xcode projects. This method provides more flexibility and ensures compatibility with modern build systems.

### Prerequisites

Before generating the Xcode projects, ensure that CMake and Xcode are installed on your macOS system. You can install CMake and the necessary libraries (`libtiff`, `libxml2`, and `wxwidgets`) using Homebrew:

```
brew install cmake libtiff libxml2 wxwidgets
```

This command will install CMake as well as the required `libtiff`, `libxml2`, and `wxwidgets` libraries needed for the project.

#### tl;dr macOS Cmake Instructions 
For those familiar with the process, here’s a quick guide to cloning the repository, reverting to a stable commit, and building the project using CMake:

```
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchoIccMAX/Build
checkout development
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
-Wno-dev Cmake/
make
```

### Generating the Xcode Project

Follow these steps to generate and build the project using CMake:

### Clone the Project Repository

Next, clone the project repository from GitHub:

```
https://github.com/xsscx/PatchIccMAX.git
```

Change into the Development Branch directory:

```
cd PatchIccMAX
checkout development
```

#### Run CMake to Generate Xcode Projects

Use CMake to configure and generate the Xcode project files.

```
cd Build/Xcode
cmake -G Xcode -DCMAKE_BUILD_TYPE=Debug ../Cmake
```

This command generates Xcode project files in the `build` directory.

#### Open the Generated Xcode Project

You can open the generated Xcode project with the following command:

```
open RefIccMAX.xcodeproj
```

Alternatively, you can open the project manually in Xcode by navigating to the `build` directory and opening the `DemoIccMAX.xcodeproj` file.

#### Build the Project via Xcode
With the project open in Xcode, you can now build it directly using the Xcode interface. The resulting binaries will be placed in the Testing folder after a successful build.

Conclusion
The CMake method for generating Xcode projects provides a streamlined and modern approach to building the Development Branch on macOS. This method is recommended for developers who prefer a flexible and compatible build process, ensuring that the project is set up correctly and efficiently on macOS.

## Building the Project on Windows

### Prerequisites

Ensure that you have the following tools installed on your Windows system:

- [Git for Windows](https://gitforwindows.org/)
- [Visual Studio 2022 Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)
- [vcpkg](https://github.com/microsoft/vcpkg)

### Build Instructions

#### Create a Temporary Directory for the Build Process

Use the following PowerShell script to create a temporary directory and set up paths for the build process:

```
    # Create a temporary directory for the build process
    $tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tempDir -Force

    # Set up paths within the temp directory
    $baseDir = "$tempDir\PatchIccMAXBuild"
    $vcpkgDir = "$baseDir\vcpkg"
    $patchDir = "$baseDir\patch"
    $outputDir = "$baseDir\output"

    # Create necessary directories
    New-Item -ItemType Directory -Path $baseDir -Force
    New-Item -ItemType Directory -Path $outputDir -Force
```

#### Clone and Set Up vcpkg

Next, clone the vcpkg repository and install the required packages:

```
    # Clone and setup vcpkg
    if (-not (Test-Path "$vcpkgDir")) {
        git clone https://github.com/microsoft/vcpkg.git $vcpkgDir
    }
    cd $vcpkgDir
    if (-not (Test-Path ".\vcpkg.exe")) {
        .\bootstrap-vcpkg.bat
    }
    .\vcpkg.exe integrate install
    .\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows
```

#### Clone and Checkout

Clone the DemoIccMAX repository and revert a commit:

```
# Clone
cd $baseDir
if (-not (Test-Path "$baseDir\PatchIccMAX")) {
    git clone https://github.com/xsscx/PatchIccMAX.git
}
cd "$baseDir\PatchIccMAX"
git checkout development
```

#### Verify and Display the Directory Contents

Verify that the solution file exists and display the directory contents if it does not:

```
    # Verify and display the directory contents
    $solutionPath = "$baseDir\DemoIccMAX\Build\MSVC\BuildAll_v22.sln"
    if (!(Test-Path $solutionPath)) {
        Write-Error "Solution file does not exist: $solutionPath"
        Get-ChildItem -Path "$baseDir\DemoIccMAX\Build\MSVC"
        exit 1
    } else {
        Write-Host "Solution file exists at: $solutionPath"
    }
```

#### Build the Project

Use MSBuild to build the project with the following command:

```
    # Build the project
    $msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
    $buildDir = "$baseDir\DemoIccMAX"
    cd $buildDir
    & $msbuildPath /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO"
```

#### Optional Cleanup

After the build process, you may choose to remove the temporary directory:

```
    # Optionally clean up the temporary directory after the build
    # Remove-Item -Recurse -Force $tempDir
```
----
## Installing the RefIccMAX CMM on Windows

To install the RefIccMAX CMM on Windows, follow these simplified steps:

### Create the Installation Directory
- Navigate to `C:\Program Files` on your system.
- Create a new directory named `RefIccMAX`.
- Copy the `RefIccMAXCmm.dll` file to `C:\Program Files\RefIccMAX`.

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

### Conclusion

This documentation is intended to assist with setting up and building the Development Branch using modern tools and practices. If you encounter any issues or have suggestions for improvement, please feel free to contribute to this repository.

---

For further information, please refer to the legacy documentation or contact the project maintainers.
