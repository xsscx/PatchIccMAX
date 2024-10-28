# -----------------------------------------------------
# DemoIccMAX Static Branch Build Script
# Author: David Hoyt
# Date: $(Get-Date -Format "yyyy-MM-dd")
# Description: This script builds the static branch of PatchIccMAX.
# -----------------------------------------------------

# Enable logging
$logFile = "C:\Testing\build_log_$(Get-Date -Format "yyyyMMdd_HHmmss").txt"
Start-Transcript -Path $logFile -Append

# Helper function for status updates
function Log-Status {
    param (
        [string]$message,
        [string]$status = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp][$status] $message"
}

# Start of script
Log-Status "Starting DemoIccMAX Static Branch Build......"

# Check if the 'Testing' directory exists, if not, create it
if (-Not (Test-Path -Path "C:\Testing")) {
    Log-Status "Directory 'C:\Testing' does not exist. Creating directory." "INFO"
    New-Item -Path "C:\Testing" -ItemType Directory
} else {
    Log-Status "Directory 'C:\Testing' already exists. Proceeding..." "INFO"
}

# Change to the Testing directory
Set-Location -Path "C:\Testing"

# Clone vcpkg repository
Log-Status "Cloning vcpkg repository..." "INFO"
git clone https://github.com/microsoft/vcpkg.git
if ($LASTEXITCODE -eq 0) {
    Log-Status "Successfully cloned vcpkg." "SUCCESS"
} else {
    Log-Status "Failed to clone vcpkg. Exiting." "ERROR"
    Stop-Transcript
    exit 1
}

# Change to vcpkg directory and run bootstrap
Set-Location -Path "C:\Testing\vcpkg"
Log-Status "Running vcpkg bootstrap..." "INFO"
.\bootstrap-vcpkg.bat
if ($LASTEXITCODE -eq 0) {
    Log-Status "vcpkg bootstrap completed." "SUCCESS"
} else {
    Log-Status "vcpkg bootstrap failed. Exiting." "ERROR"
    Stop-Transcript
    exit 1
}

# Integrate vcpkg
Log-Status "Integrating vcpkg..." "INFO"
.\vcpkg.exe integrate install
if ($LASTEXITCODE -eq 0) {
    Log-Status "vcpkg integration successful." "SUCCESS"
} else {
    Log-Status "vcpkg integration failed. Exiting." "ERROR"
    Stop-Transcript
    exit 1
}

# Install dependencies
Log-Status "Installing dependencies via vcpkg..." "INFO"
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows `
                   libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static
if ($LASTEXITCODE -eq 0) {
    Log-Status "Dependencies installed successfully." "SUCCESS"
} else {
    Log-Status "Failed to install dependencies. Exiting." "ERROR"
    Stop-Transcript
    exit 1
}

# Clone PatchIccMAX repository
Set-Location -Path "C:\Testing"
Log-Status "Cloning PatchIccMAX repository..." "INFO"
git clone https://github.com/xsscx/PatchIccMAX.git
if ($LASTEXITCODE -eq 0) {
    Log-Status "Successfully cloned PatchIccMAX." "SUCCESS"
} else {
    Log-Status "Failed to clone PatchIccMAX. Exiting." "ERROR"
    Stop-Transcript
    exit 1
}

# Checkout the static branch
Set-Location -Path "C:\Testing\PatchIccMAX"
Log-Status "Checking out 'static' branch..." "INFO"
git checkout static
if ($LASTEXITCODE -eq 0) {
    Log-Status "Checked out 'static' branch successfully." "SUCCESS"
} else {
    Log-Status "Failed to checkout 'static' branch. Exiting." "ERROR"
    Stop-Transcript
    exit 1
}

# Start build process
Log-Status "Starting build process..." "INFO"
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln `
    /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static `
    /p:CLToolAdditionalOptions="/MT /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" `
    /p:PreprocessorDefinitions="STATIC_LINK" `
    /p:RuntimeLibrary=MultiThreaded `
    /p:AdditionalLibraryDirectories="C:\Testing\vcpkg\installed\x64-windows-static\lib" `
    /p:AdditionalDependencies="wxmsw32u_core.lib;wxbase32u.lib;%(AdditionalDependencies)" `
    /p:LinkToolAdditionalOptions="/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" `
    /t:Clean,Build /bl /verbosity:minimal

if ($LASTEXITCODE -eq 0) {
    Log-Status "Build succeeded." "SUCCESS"
} else {
    Log-Status "Build failed with exit code $LASTEXITCODE." "ERROR"
}

# End of script
Log-Status "Build process completed." "INFO"

# Stop logging
Stop-Transcript
