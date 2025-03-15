# ========================== PatchIccMAX ASAN Branch Build Script for VS2022 Community ==========================
# © 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Date: 15-MAR-2025 1252 EDT by David Hoyt
#
#
#
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/msvc/contrib/Build/VS2022C/build_asan_runner.ps1").Content
#
#
# Intent: Automate build, integration, and testing for the PatchIccMAX ASAN branch using Visual Studio 2022
#
#
#
#
#
#
#
#
# ==============================================================================================

# Start of Script
Write-Host "============================= Starting PatchIccMAX ASAN Branch Build =============================" -ForegroundColor Green
Write-Host "(©) 2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor Green
Write-Host "Last Updated 25-FEB-2025 1522 EST by David Hoyt" -ForegroundColor Green
Write-Host "https://srd.cx" -ForegroundColor Green
set MSBUILDDEBUGENGINE=1
# === Function Definitions ===

function Log-Message {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host "$Message" -ForegroundColor $Color
}

function Ensure-DirectoryExists {
    param (
        [string]$Path
    )
    if (-Not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force
    }
}

function Run-Command {
    param (
        [string]$Command
    )
    try {
        Invoke-Expression $Command
    } catch {
        Log-Message "Error executing: $Command. Exception: $_" "Red"
        throw
    }
}

# === Script Start ===
Log-Message "Starting PatchIccMAX ASAN Branch Build for VS2022 Community" "Green"

# === Environment Setup ===
Log-Message "Setting up directories and environment variables..."
chcp 65001
$Env:VSCMD_ARG_HOST_ARCH = "x64"
$Env:VSCMD_ARG_TGT_ARCH = "x64"
$BaseDir = "C:\test"
$vcpkgDir = "$BaseDir\vcpkg"
$patchDir = "$BaseDir\PatchIccMAX"

Ensure-DirectoryExists -Path $BaseDir

# === Git Configuration ===
Log-Message "Configuring Git user..."
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# === vcpkg Setup ===
Log-Message "Cloning and bootstrapping vcpkg..."
Run-Command "git clone https://github.com/microsoft/vcpkg.git $vcpkgDir"
Run-Command "cd $vcpkgDir; .\bootstrap-vcpkg.bat"
Run-Command "cd $vcpkgDir; .\vcpkg.exe integrate install"
Run-Command ".\vcpkg.exe install nlohmann-json:x64-windows nlohmann-json:x64-windows-static libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static"

# === PatchIccMAX Setup ===
Log-Message "Cloning PatchIccMAX repository..."
Run-Command "git clone https://github.com/xsscx/PatchIccMAX.git $patchDir"
Run-Command "cd $patchDir; git checkout msvc"

Log-Message "Building PatchIccMAX using MSBuild with ASAN..."
copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib
Run-Command "msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Asan /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /O2 /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /INCREMENTAL:NO" /t:Clean,Build"

# === Testing ===
Log-Message "Setting up testing environment..."
Ensure-DirectoryExists -Path "$patchDir\Testing"
Run-Command "copy $vcpkgDir\installed\x64-windows\bin\*.dll $patchDir\Testing\"
# Run-Command "copy 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x64\clang_rt.asan_dynamic-x86_64.dll' $patchDir\Testing\"
Log-Message "Fixups for libs"

Log-Message "Adding vcpkg bin directory to PATH, Setting ASAN Options..."
$Env:PATH = "$vcpkgDir\installed\x64-windows\bin;$Env:PATH"
# $env:ASAN_OPTIONS="verbosity=1,log_path=asan.log"
$env:ASAN_OPTIONS = "verbosity=1,log_path=asan.log,detect_leaks=0,strict_string_checks=1,fast_unwind_on_malloc=0"
Write-Host "ASAN_OPTIONS: $env:ASAN_OPTIONS"

copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib
Run-Command "msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Asan /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /O2 /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /INCREMENTAL:NO" msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Asan /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /O2 /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /INCREMENTAL:NO"  /verbosity:diagnostic /bl  /noconlog /flp:v=diag /p:LinkToolAdditionalOptions="/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" /t:Clean,Build"

Log-Message "Done with PatchIccMAX ASAN Branch Build" "Cyan"
