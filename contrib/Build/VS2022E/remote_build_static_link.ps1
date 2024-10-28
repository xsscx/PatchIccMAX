# -----------------------------------------------------
# DemoIccMAX Static Branch Build Script
# Author: [Your Name]
# Date: $(Get-Date -Format "yyyy-MM-dd")
# Description: This script builds the static branch of PatchIccMAX with improved UI/UX.
# -----------------------------------------------------

# Helper function for status updates with color
function Log-Status {
    param (
        [string]$message,
        [string]$status = "INFO",  # Status: INFO, SUCCESS, WARNING, ERROR
        [int]$timer = 0            # Time in seconds for step completion (optional)
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $timerMessage = ""
    if ($timer -gt 0) {
        $timerMessage = " (Time taken: $timer seconds)"
    }

    switch ($status) {
        "INFO"     { Write-Host "[$timestamp][INFO] $message$timerMessage" -ForegroundColor White }
        "SUCCESS"  { Write-Host "[$timestamp][SUCCESS] $message$timerMessage" -ForegroundColor Green }
        "WARNING"  { Write-Host "[$timestamp][WARNING] $message$timerMessage" -ForegroundColor Yellow }
        "ERROR"    { Write-Host "[$timestamp][ERROR] $message$timerMessage" -ForegroundColor Red }
    }
}

# Start script timer
$scriptStartTime = Get-Date

# Check if the 'Testing' directory exists, if not, create it
if (-Not (Test-Path -Path "C:\Testing")) {
    Log-Status "Directory 'C:\Testing' does not exist. Creating directory." "INFO"
    New-Item -Path "C:\Testing" -ItemType Directory
} else {
    Log-Status "Directory 'C:\Testing' already exists. Proceeding..." "INFO"
}

# Now create log file after ensuring directory exists
$logFile = "C:\Testing\build_log_$(Get-Date -Format "yyyyMMdd_HHmmss").txt"
Start-Transcript -Path $logFile -Append

# Start of script
Log-Status "Starting DemoIccMAX Static Branch Build......" "INFO"

# Function to time and log execution of a block of code
function Time-Execution {
    param (
        [ScriptBlock]$Code,
        [string]$taskName
    )

    $startTime = Get-Date
    Invoke-Command $Code
    $endTime = Get-Date
    $elapsedTime = ($endTime - $startTime).TotalSeconds
    return [math]::Round($elapsedTime, 2)
}

# Step: Clone vcpkg repository
$cloneVcpkgTime = Time-Execution -Code {
    Log-Status "Cloning vcpkg repository..." "INFO"
    git clone https://github.com/microsoft/vcpkg.git
    if ($LASTEXITCODE -eq 0) {
        Log-Status "Successfully cloned vcpkg." "SUCCESS"
    } else {
        Log-Status "Failed to clone vcpkg. Exiting." "ERROR"
        Stop-Transcript
        exit 1
    }
} -taskName "Cloning vcpkg"
Log-Status "Finished cloning vcpkg" "SUCCESS" $cloneVcpkgTime

# Step: Bootstrap vcpkg
$bootstrapTime = Time-Execution -Code {
    Log-Status "Running vcpkg bootstrap..." "INFO"
    Set-Location -Path "C:\Testing\vcpkg"
    .\bootstrap-vcpkg.bat
    if ($LASTEXITCODE -eq 0) {
        Log-Status "vcpkg bootstrap completed." "SUCCESS"
    } else {
        Log-Status "vcpkg bootstrap failed. Exiting." "ERROR"
        Stop-Transcript
        exit 1
    }
} -taskName "Bootstrapping vcpkg"
Log-Status "Finished bootstrapping vcpkg" "SUCCESS" $bootstrapTime

# Step: Install dependencies
$installDepsTime = Time-Execution -Code {
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
} -taskName "Installing dependencies"
Log-Status "Finished installing dependencies" "SUCCESS" $installDepsTime

# Step: Clone PatchIccMAX repository
$clonePatchIccMAXTime = Time-Execution -Code {
    Log-Status "Cloning PatchIccMAX repository..." "INFO"
    Set-Location -Path "C:\Testing"
    git clone https://github.com/xsscx/PatchIccMAX.git
    if ($LASTEXITCODE -eq 0) {
        Log-Status "Successfully cloned PatchIccMAX." "SUCCESS"
    } else {
        Log-Status "Failed to clone PatchIccMAX. Exiting." "ERROR"
        Stop-Transcript
        exit 1
    }
} -taskName "Cloning PatchIccMAX"
Log-Status "Finished cloning PatchIccMAX" "SUCCESS" $clonePatchIccMAXTime

# Step: Checkout the static branch
$checkoutStaticTime = Time-Execution -Code {
    Log-Status "Checking out 'static' branch..." "INFO"
    Set-Location -Path "C:\Testing\PatchIccMAX"
    git checkout static
    if ($LASTEXITCODE -eq 0) {
        Log-Status "Checked out 'static' branch successfully." "SUCCESS"
    } else {
        Log-Status "Failed to checkout 'static' branch. Exiting." "ERROR"
        Stop-Transcript
        exit 1
    }
} -taskName "Checking out static branch"
Log-Status "Finished checking out static branch" "SUCCESS" $checkoutStaticTime

# Step: Start build process
$buildTime = Time-Execution -Code {
    Log-Status "Starting build process..." "INFO"
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:CLToolAdditionalOptions="/MT /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /p:PreprocessorDefinitions="STATIC_LINK" /p:RuntimeLibrary=MultiThreaded /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:AdditionalDependencies="wxmsw32u_core.lib%3Bwxbase32u.lib%3B%(AdditionalDependencies)" /p:LinkToolAdditionalOptions="/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" /t:Clean,Build
    if ($LASTEXITCODE -eq 0) {
        Log-Status "Build succeeded." "SUCCESS"
    } else {
        Log-Status "Build failed with exit code $LASTEXITCODE." "ERROR"
    }
} -taskName "Build Process"
Log-Status "Build process completed" "SUCCESS" $buildTime

# End of script timer
$scriptEndTime = Get-Date
$totalScriptTime = [math]::Round(($scriptEndTime - $scriptStartTime).TotalSeconds, 2)
Log-Status "Total time taken for the build script: $totalScriptTime seconds." "INFO"

# Stop logging
Stop-Transcript
