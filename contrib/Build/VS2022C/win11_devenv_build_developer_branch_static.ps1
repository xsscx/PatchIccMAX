# ========================== DemoIccMAX Development Branch Build Script ==========================
# DemoIccMAX Static Branch Build Script
# Copyright (c) 2024 The International Color Consortium. All rights reserved.
# Author: David Hoyt
# Date: $(Get-Date -Format "yyyy-MM-dd")
# Description: This script builds the development branch of PatchIccMAX with improved UI/UX.
# This script automates the process of setting up a build environment for DemoIccMAX.
# It will clone the necessary repositories, install dependencies, and perform a build
# for the 'development' branch of PatchIccMAX.
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/win11_devenv_build_developer_branch_static.ps1").Content
#
# ============================================================


# Start of Script
Write-Host "============================= Starting DemoIccMAX Development Branch Build =============================" -ForegroundColor Green
$env:VSCMD_ARG_HOST_ARCH = "x64"
$env:VSCMD_ARG_TGT_ARCH = "x64"
Write-Host "Copyright (c) 2024 The International Color Consortium. All rights reserved." -ForegroundColor Green
Write-Host "Author: David Hoyt written for ICC color.org and DemoIccMAX Project" -ForegroundColor Green

# Set up directories and environment variables
$optDir = "C:\test"
$vcpkgDir = "$optDir\vcpkg"
$patchDir = "$optDir\PatchIccMAX"

# Setup anon git
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Create the /opt directory if it doesn't exist
if (-Not (Test-Path $optDir)) {
    New-Item -ItemType Directory -Path $optDir
}

# Clone vcpkg repository and bootstrap
Write-Host "Cloning vcpkg repository..."
cd $optDir
git clone https://github.com/microsoft/vcpkg.git
cd $vcpkgDir
Write-Host "Bootstrapping vcpkg..."
.\bootstrap-vcpkg.bat

# Integrate vcpkg and install dependencies
Write-Host "Integrating vcpkg..."
.\vcpkg.exe integrate install

Write-Host "Installing required libraries (libxml2, tiff, wxwidgets) for x64-windows-static..."
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static

# Clone the PatchIccMAX repository
Write-Host "Cloning PatchIccMAX repository..."
cd $optDir
git clone https://github.com/xsscx/PatchIccMAX.git

# Checkout the development branch
cd $patchDir
git checkout development

# Build the project using msbuild
Write-Host "Building the project..."
msbuild  /m /maxcpucount "Build\MSVC\BuildAll_v22.sln" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
Write-Host "All Done!"
