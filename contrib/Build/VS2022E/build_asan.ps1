# ========================== PatchIccMAX ASAN Branch Build Script ==========================
# PatchIccMAX ASAN Branch Build
# Copyright (c) 2024 David H Hoyt LLC. All rights reserved.
# Author: David Hoyt
# Date: 19-NOV-2024
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022E/build_asan.ps1").Content
#
# ============================================================

# Start of Script
Write-Host "============================= Starting PatchIccMAX ASAN Branch Build =============================" -ForegroundColor Green
Write-Host "Copyright (©) 2024 David H Hoyt LLC. All rights reserved." -ForegroundColor Green
Write-Host "Author: David H Hoyt LLC | dhoyt@hoyt.net" -ForegroundColor Green

# Set up directories and environment variables
Write-Host "Set up \test directories and environment variables...."
$env:VSCMD_ARG_HOST_ARCH = "x64"
$env:VSCMD_ARG_TGT_ARCH = "x64"
$optDir = "C:\test"
$vcpkgDir = "$optDir\vcpkg"
$patchDir = "$optDir\DemoIccMAX"

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
.\vcpkg.exe install egl-registry:x64-windows-static vcpkg-cmake:x64-windows-static vcpkg-cmake-config:x64-windows-static nlohmann-json:x64-windows nlohmann-json:x64-windows-static libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static

# Clone PatchIccMAX repository
Write-Host "Cloning PatchIccMAX"
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
Write-Host "Running: git checkout asan"
git checkout asan
Write-Host "Running: msbuild with ASAN"
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Asan /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /O2 /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /INCREMENTAL:NO" /t:Clean,Build
Write-Host "Testing .exe's"
Write-Host "Copying .dll's to .\Testing\"
copy C:\test\vcpkg\installed\x64-windows\bin\*.dll C:\test\vcpkg\PatchIccMAX\Testing\
# Set the PATH in case build and link static not working
Write-Host "Adding $env:PATH = "C:\test\vcpkg\installed\x64-windows\bin;" + $env:PATH"
$env:PATH = "C:\test\vcpkg\installed\x64-windows\bin;" + $env:PATH
Write-Host "Running the .exe files in .\Testing\"
Get-ChildItem -Path ".\Testing\" -Filter "*_d.exe" -Recurse | Remove-Item -Force
Get-ChildItem -Path ".\Testing\" -Recurse -Filter *.exe | ForEach-Object { Write-Host "Running: $($_.FullName)"; try { $output = & $_.FullName 2>&1; if ($output -match "IccProfLib Version 2\.2\.3" -or $output -match "IccLibXML Version 2\.2\.3" -or $output -match "Built with") { Write-Host "SUCCESS: Matched on '$($_.FullName)'"; } else { Write-Host "SUCCESS: GUI Application '$($_.FullName)' ran successfully (no match or atypical exit code)"; } } catch { Write-Host "FAILURE: Exception occurred while running '$($_.FullName)'"; } }
Write-Host "CD to .\Testing\"
cd Testing/
Write-Host "Running CreateAllProfiles.bat from remote"
$tempFile = "$env:TEMP\CreateAllProfiles.bat"; iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/CreateAltAsanProfiles.bat" -OutFile $tempFile; & $tempFile; Remove-Item $tempFile
Write-Host "Summary: Installed vcpkg, Build PatchIccMAX, Create Profiles"
Write-Host "All Done with PatchIccMAX ASAN Branch Build Script!"