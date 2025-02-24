# ========================== PatchIccMAX ASAN ALT Build Script for VS2022 Community ==========================
# © 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Date: 25-FEB-2025 1522 by David Hoyt
#
#
#
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/msvc/contrib/Build/VS2022C/build_asan_alt.ps1").Content
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

# ==================================================================================
# Start of Script
# ==================================================================================
$logFile = "C:\test\PatchIccMAX_ASAN_Build.log"
function Log-Message {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry -ForegroundColor $Color
    Add-Content -Path $logFile -Value $logEntry
}

function Ensure-DirectoryExists {
    param ([string]$Path)
    if (-Not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Run-Command {
    param ([string]$Command)
    try {
        Log-Message "Executing: $Command" "Yellow"
        Invoke-Expression $Command 2>&1 | Tee-Object -FilePath $logFile -Append
    } catch {
        Log-Message "ERROR: Failed to execute: $Command. Exception: $_" "Red"
        throw
    }
}

# ==================================================================================
# ENTRY BANNER
# ==================================================================================
Log-Message "==================== PatchIccMAX ASAN Branch Build ====================" "Green"
Log-Message "(©) 2024-2025 David H Hoyt LLC. All rights reserved."
Log-Message "Last Updated: 25-FEB-2025 1522 EST by David Hoyt"
Log-Message "https://srd.cx"
Log-Message "======================================================================="

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
Run-Command "git config --global user.email 'you@example.com'"
Run-Command "git config --global user.name 'Your Name'"

# === vcpkg Setup ===
Log-Message "Cloning and bootstrapping vcpkg..."
Run-Command "git clone https://github.com/microsoft/vcpkg.git $vcpkgDir"
Run-Command "cd $vcpkgDir; .\bootstrap-vcpkg.bat"
Run-Command "cd $vcpkgDir; .\vcpkg.exe integrate install"
Run-Command ".\vcpkg.exe install nlohmann-json:x64-windows nlohmann-json:x64-windows-static libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows"

# === PatchIccMAX Setup ===
Log-Message "Cloning PatchIccMAX repository..."
Run-Command "git clone https://github.com/xsscx/PatchIccMAX.git $patchDir"
Run-Command "cd $patchDir; git checkout msvc"

Log-Message "Building PatchIccMAX using MSBuild with ASAN..."
Run-Command "copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib"
Run-Command "msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Asan /p:Platform=x64 /p:AdditionalIncludeDirectories='$vcpkgDir\installed\x64-windows\include' /p:AdditionalLibraryDirectories='$vcpkgDir\installed\x64-windows\lib' /p:CLToolAdditionalOptions='/fsanitize=address /O2 /W4' /p:LinkToolAdditionalOptions='/fsanitize=address /INCREMENTAL:NO' /t:Clean,Build"

# === Testing ===
Log-Message "Setting up testing environment..."
Ensure-DirectoryExists -Path "$patchDir\Testing"
Run-Command "copy $vcpkgDir\installed\x64-windows\bin\*.dll $patchDir\Testing\"
Run-Command "copy 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x64\clang_rt.asan_dynamic-x86_64.dll' $patchDir\Testing\"

Log-Message "Adding vcpkg bin directory to PATH, Setting ASAN Options..."
$Env:PATH = "$vcpkgDir\installed\x64-windows\bin;$Env:PATH"
$Env:ASAN_OPTIONS = "verbosity=1,log_path=asan.log,detect_leaks=0,strict_string_checks=1,fast_unwind_on_malloc=0"
Log-Message "ASAN_OPTIONS: $Env:ASAN_OPTIONS"

Run-Command "msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Asan /p:Platform=x64 /p:AdditionalIncludeDirectories='$vcpkgDir\installed\x64-windows\include' /p:AdditionalLibraryDirectories='$vcpkgDir\installed\x64-windows\lib' /p:CLToolAdditionalOptions='/fsanitize=address /O2 /W4' /p:LinkToolAdditionalOptions='/fsanitize=address /INCREMENTAL:NO' /t:Build"

# === Final Steps ===
Set-Location "$patchDir\Testing"
Log-Message "Creating profiles using remote batch script..."
$tempFile = "$Env:TEMP\CreateAllProfiles.bat"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/development/contrib/UnitTest/CreateAltAsanProfiles.bat" -OutFile $tempFile
Start-Process cmd.exe -ArgumentList "/c `"$tempFile`"" -Wait
Remove-Item $tempFile -Force

Log-Message "Running RunTests.bat from local"
Run-Command ".\RunTests.bat"

# Collect .icc profile information
$profiles = Get-ChildItem -Path . -Filter "*.icc" -Recurse -File
$totalCount = $profiles.Count

# Generate Summary Report
Log-Message "========================= ICC Profile Report ========================="
$groupedProfiles = $profiles | Group-Object { $_.Directory.FullName }
foreach ($group in $groupedProfiles) {
    Log-Message ("{0}: {1} .icc profiles" -f $group.Name, $group.Count)
}
Log-Message "Total .icc profiles found: $totalCount"
Log-Message "======================================================================"

[System.Environment]::SetEnvironmentVariable(
    "Path",
    "C:\test\vcpkg\installed\x64-windows\debug\bin;C:\test\vcpkg\installed\x64-windows\debug\lib;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x64;" +
    [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User),
    [System.EnvironmentVariableTarget]::User
)

# ==================================================================================
# EXIT BANNER
# ==================================================================================
Log-Message "==================== PatchIccMAX ASAN ALT Build Completed ====================" "Cyan"
Log-Message "Build and testing completed. Logs saved to: $logFile"
Log-Message "================================================================================="
