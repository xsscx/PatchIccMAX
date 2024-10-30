# ========================== DemoIccMAX Static Branch Build Script ==========================
# DemoIccMAX Static Branch Build Script
# Copyright (c) 2024 The International Color Consortium. All rights reserved.
# Author: David Hoyt
# Date: $(Get-Date -Format "yyyy-MM-dd")
# Description: This script builds the static branch of PatchIccMAX with improved UI/UX.
# This script automates the process of setting up a build environment for DemoIccMAX.
# It will clone the necessary repositories, install dependencies, and perform a build
# for the 'static' branch of PatchIccMAX.

# Start of Script
Write-Host "============================= Starting DemoIccMAX Static Branch Build =============================" -ForegroundColor Green
$env:VSCMD_ARG_HOST_ARCH = "x64"
$env:VSCMD_ARG_TGT_ARCH = "x64"
Write-Host "Copyright (c) 2024 The International Color Consortium. All rights reserved." -ForegroundColor Green
Write-Host "Author: David Hoyt dhoyt@hoyt.net" -ForegroundColor Green

# Banner
$banner = @"
========================================
        DemoIccMAX Static Branch Build
========================================
"@
Write-Host $banner

# Function for logging
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$level] $message"
}

# Error handling
trap {
    Log-Message "An error occurred: $_" "ERROR"
    exit 1
}

Log-Message "Starting DemoIccMAX Static Branch Build..."

# Create testing directory
if (-not (Test-Path -Path "C:\testing")) {
    Log-Message "Creating testing directory..."
    mkdir C:\testing
} else {
    Log-Message "Testing directory already exists."
}

cd C:\testing

# Clone vcpkg repository
if (-not (Test-Path -Path "C:\testing\vcpkg")) {
    Log-Message "Cloning vcpkg repository..."
    git clone https://github.com/microsoft/vcpkg.git
} else {
    Log-Message "vcpkg repository already exists, skipping clone."
}

cd vcpkg
Log-Message "Bootstrapping vcpkg..."
.\bootstrap-vcpkg.bat

# Integrate vcpkg with specified root path
Log-Message "Integrating vcpkg..."
.\vcpkg.exe integrate install --vcpkg-root "C:\testing\vcpkg"

# Install required libraries with explicit triplet and root path
Log-Message "Installing required libraries..."
$requiredPackages = @(
    "libxml2:x64-windows",
    "tiff:x64-windows",
    "wxwidgets:x64-windows",
    "libxml2:x64-windows-static",
    "tiff:x64-windows-static",
    "wxwidgets:x64-windows-static"
)

foreach ($package in $requiredPackages) {
    Log-Message "Installing package: $package..."
    .\vcpkg.exe install $package --vcpkg-root "C:\testing\vcpkg" --triplet x64-windows
}

cd C:\testing

# Clone PatchIccMAX repository
if (-not (Test-Path -Path "C:\testing\PatchIccMAX")) {
    Log-Message "Cloning PatchIccMAX repository..."
    git clone https://github.com/xsscx/PatchIccMAX.git
} else {
    Log-Message "PatchIccMAX repository already exists, skipping clone."
}

cd PatchIccMAX

# Checkout the 'static' branch
Log-Message "Checking out 'static' branch..."
git checkout static

# Start the build process
Log-Message "Starting build process..."
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln `
    /p:Configuration=Release `
    /p:Platform=x64 `
    /p:VcpkgTriplet=x64-windows-static `
    /p:CLToolAdditionalOptions="/MT /W4" `
    /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" `
    /p:PreprocessorDefinitions="STATIC_LINK" `
    /p:RuntimeLibrary=MultiThreaded `
    /p:AdditionalLibraryDirectories="C:\testing\vcpkg\installed\x64-windows-static\lib" `
    /p:AdditionalDependencies="wxmsw32u_core.lib%3Bwxbase32u.lib%3B%(AdditionalDependencies)" `
    /p:LinkToolAdditionalOptions="/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" `
    /t:Clean,Build /bl /verbosity:minimal > $null 2>&1

# Check build result
if ($LASTEXITCODE -eq 0) {
    Log-Message "Build succeeded." "SUCCESS"
} else {
    Log-Message "Build failed with exit code $LASTEXITCODE." "ERROR"
}

Write-Host "Running the .exe files built"
# copy ..\..\vcpkg\installed\x64-windows-static\lib\tiff.lib  ..\..\vcpkg\installed\x64-windows-static\lib\libtiff.lib
Get-ChildItem -Path "." -Recurse -Filter *.exe | ForEach-Object { Write-Host "Running: $($_.FullName)"; & $_.FullName }

Write-Host "Running CreateAllProfiles.bat from remote"
$tempFile = "$env:TEMP\CreateAllProfiles.bat"; iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/CreateAllProfiles.bat" -OutFile $tempFile; & $tempFile; Remove-Item $tempFile

Write-Host "All Done!"
