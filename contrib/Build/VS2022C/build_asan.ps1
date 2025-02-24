# ========================== PatchIccMAX ASAN Branch Build Script for VS2022 Community ==========================
# © 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Date: 24-FEB-2025 1704 by David Hoyt
#
#
#
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/msvc/contrib/Build/VS2022C/build_asan.ps1").Content
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
Write-Host "https://srd.cx" -ForegroundColor Green

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
Run-Command "msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Asan /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /O2 /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /INCREMENTAL:NO" /t:Clean,Build"

# === Testing ===
Log-Message "Setting up testing environment..."
Ensure-DirectoryExists -Path "$patchDir\Testing"
Run-Command "copy $vcpkgDir\installed\x64-windows\bin\*.dll $patchDir\Testing\"
Run-Command "copy 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x64\clang_rt.asan_dynamic-x86_64.dll' $patchDir\Testing\"
Log-Message "Fixups for libs"
copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib
copy C:\test\vcpkg\installed\x64-windows-static\lib\tiff.lib C:\test\vcpkg\installed\x64-windows-static\lib\libtiff.lib
copy C:\test\vcpkg\installed\x64-windows-static\lib\tiff.lib C:\test\vcpkg\installed\x64-windows-static\lib\libtiff.lib
copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib

Log-Message "Adding vcpkg bin directory to PATH, Setting ASAN Options..."
$Env:PATH = "$vcpkgDir\installed\x64-windows\bin;$Env:PATH"
$env:ASAN_OPTIONS="verbosity=1,log_path=asan.log"
Write-Host "ASAN_OPTIONS: $env:ASAN_OPTIONS"

Log-Message "Running .exe tests in Testing directory..."
Get-ChildItem -Path "$patchDir\Testing" -Filter "*.exe" -Recurse | ForEach-Object {
    Log-Message "Executing: $($_.FullName)"
    try {
        $output = & $_.FullName 2>&1
        if ($output -match "IccProfLib Version 2\.2\.3" -or $output -match "IccLibXML Version 2\.2\.3") {
            Log-Message "SUCCESS: $($_.FullName)" "Green"
        } else {
            Log-Message "Executed $($_.FullName) successfully" "Yellow"
        }
    } catch {
        Log-Message "FAILURE: Exception in $($_.FullName): $_" "Red"
    }
}

# === Final Steps ===
cd Testing/
Log-Message "Creating profiles using remote batch script..."

# Define the temporary file path
$tempFile = "$Env:TEMP\CreateAllProfiles.bat"

# Download the batch script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/development/contrib/UnitTest/CreateAltAsanProfiles.bat" -OutFile $tempFile

# Run the batch file in a new cmd session
Start-Process cmd.exe -ArgumentList "/c `"$tempFile`"" -Wait

# Clean up the temporary batch file
Remove-Item $tempFile -Force

Log-Message "Done with PatchIccMAX ASAN Branch Build" "Cyan"
