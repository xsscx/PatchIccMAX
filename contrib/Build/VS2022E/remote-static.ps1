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

Write-Host "Creating 'testing' directory..." -ForegroundColor Yellow

# Create testing directory
mkdir \testing
cd \testing

# Log process initiation
Write-Host "Cloning the vcpkg repository..." -ForegroundColor Cyan

# Clone vcpkg repository
git clone https://github.com/microsoft/vcpkg.git

# Move into vcpkg directory
cd vcpkg
Write-Host "Bootstrapping vcpkg..." -ForegroundColor Yellow

# Bootstrap and install vcpkg
.\bootstrap-vcpkg.bat
Write-Host "Integrating vcpkg with Visual Studio..." -ForegroundColor Yellow
.\vcpkg.exe integrate install

# Install required libraries
Write-Host "Installing necessary libraries: libxml2, tiff, wxwidgets (static and dynamic)..." -ForegroundColor Yellow
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows `
                    libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static

# Return to testing directory
cd \testing

# Log PatchIccMAX cloning
Write-Host "Cloning PatchIccMAX repository..." -ForegroundColor Cyan
git clone https://github.com/xsscx/PatchIccMAX.git

# Move into PatchIccMAX directory
cd PatchIccMAX

# Checkout static branch
Write-Host "Checking out the 'static' branch..." -ForegroundColor Yellow
git checkout static

# Log build initiation
Write-Host "============================= Starting Build Process =============================" -ForegroundColor Green

# Build the project using msbuild with all the necessary parameters
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Release /p:Platform=x64 `
        /p:VcpkgTriplet=x64-windows-static `
        /p:CLToolAdditionalOptions="/MT /W4" `
        /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" `
        /p:PreprocessorDefinitions="STATIC_LINK" `
        /p:RuntimeLibrary=MultiThreaded `
        /p:AdditionalLibraryDirectories="C:\testing\vcpkg\installed\x64-windows-static\lib" `
        /p:AdditionalDependencies="wxmsw32u_core.lib%3Bwxbase32u.lib%3B%(AdditionalDependencies)" `
        /p:LinkToolAdditionalOptions="/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" `
        /t:Clean,Build /bl /verbosity:minimal > $null 2>&1

# Check build result and log accordingly
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build succeeded." -ForegroundColor Green
} else {
    Write-Host "Build failed with exit code $LASTEXITCODE." -ForegroundColor Red
}

Write-Host "Running the .exe files built"
# copy ..\..\vcpkg\installed\x64-windows-static\lib\tiff.lib  ..\..\vcpkg\installed\x64-windows-static\lib\libtiff.lib
Get-ChildItem -Path "." -Recurse -Filter *.exe | ForEach-Object { Write-Host "Running: $($_.FullName)"; & $_.FullName }

Write-Host "Running CreateAllProfiles.bat from remote"
$tempFile = "$env:TEMP\CreateAllProfiles.bat"; iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/CreateAllProfiles.bat" -OutFile $tempFile; & $tempFile; Remove-Item $tempFile

# End of Script
Write-Host "============================= DemoIccMAX Build Complete =============================" -ForegroundColor Green
