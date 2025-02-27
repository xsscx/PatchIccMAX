# ========================== IccMAX Windows Asan Build Dependency Report< Script ==========================
#
#
# Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved.
# Author: David Hoyt
# Date: 26-FEB-2025 1547 EST by David Hoyt
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/msvc/contrib/Build/VS2022C/asan-link-dep-report.ps1").Content
#
# ============================================================

# Start of Script
Write-Host "============================= Starting DemoIccMAX Master Branch Build =============================" -ForegroundColor Green
Write-Host "Copyright (c) 2024-2025  2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor Green
Write-Host "Last Updated: 26-FEB-2025 1547 EST by David H Hoyt LLC" -ForegroundColor Green

# PowerShell Script: Dependency Analysis with Logging & HTML Report

# PowerShell Script: Dependency Analysis with Logging & HTML Report

$logFile = "dependency_analysis.log"
$htmlReport = "dependency_report.html"
$msbuildLog = "msbuild.log"
$cmakeLists = "Build/Cmake/CMakeLists.txt"
$gitStatusLog = "git_status.log"
$systemInfoLog = "system_info.log"

# Entry Banner
Write-Output "======================================"
Write-Output " ICC Asan Build Dependency Analysis Script "
Write-Output "======================================"
Write-Output "Start Time: $(Get-Date)" | Tee-Object -FilePath $logFile -Append

# Gather System & Developer Info
Write-Output "Collecting system and developer environment details..." | Tee-Object -FilePath $logFile -Append

# Check if msbuild is available
$msbuildPath = (Get-Command msbuild -ErrorAction SilentlyContinue).Source
if ($msbuildPath) {
    $msbuildVersion = & $msbuildPath /version 2>&1 | Select-String "Version"
} else {
    $msbuildVersion = "MSBuild not found in system PATH"
}

# Get system information with fallbacks
$hostname = $env:COMPUTERNAME
if (-not $hostname) { $hostname = "Unknown" }

$osVersion = (Get-CimInstance Win32_OperatingSystem).Caption
if (-not $osVersion) { $osVersion = "Unknown" }

$vsVersion = (Get-Command "devenv.exe" -ErrorAction SilentlyContinue).Source
if (-not $vsVersion) { $vsVersion = "Not Installed" }

$systemInfo = @{
    "Hostname" = $hostname
    "OS Version" = $osVersion
    "MSBuild Version" = $msbuildVersion
    "Visual Studio 2022 Edition" = $vsVersion
}
$systemInfo | Out-File -FilePath $systemInfoLog

# Git Repository Information
Write-Output "Collecting Git status..." | Tee-Object -FilePath $logFile -Append
$gitStatus = git status 2>&1
$gitStatus | Out-File -FilePath $gitStatusLog

# Initialize HTML Report with Secure Formatting
$reportContent = @"
<html>
<head>
<title>IccMAX Windows Asan Build Dependency Report</title>
<style>
body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
pre, code { background-color: #f4f4f4; padding: 10px; border-radius: 5px; white-space: pre-wrap; font-family: monospace; }
table { border-collapse: collapse; width: 100%; margin-top: 20px; }
th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
th { background-color: #f2f2f2; }
ul { list-style-type: none; padding: 0; }
li { margin-bottom: 5px; }
</style>
</head>
<body>
<h2>IccMAX Windows Asan Build Dependency Report</h2>
<h3>System & Developer Info</h3>
<ul>
<li><strong>Hostname:</strong> $($systemInfo["Hostname"])</li>
<li><strong>OS Version:</strong> $($systemInfo["OS Version"])</li>
<li><strong>MSBuild Version:</strong> $($systemInfo["MSBuild Version"])</li>
<li><strong>Visual Studio 2022 Edition:</strong> $($systemInfo["Visual Studio 2022 Edition"])</li>
</ul>
<h3>Git Repository Status</h3>
<pre>$(Get-Content -Path $gitStatusLog -Raw)</pre>
<h3>Dependencies</h3>
<table>
<tr><th>Executable</th><th>Dependencies</th></tr>
"@

# Define Paths
$paths = @("IccXML", "Tools/")
$executables = Get-ChildItem -Path $paths -Recurse -Include *.exe

# Process Each Executable
foreach ($exe in $executables) {
    Write-Output "Checking: $($exe)" | Tee-Object -FilePath $logFile -Append
    $dependencies = link /dump /dependents $exe 2>&1 | 
        Select-String -NotMatch ".data|.pdata|.reloc|.rsrc|.text|.INTR|.WEAK|.debug|.00cfg|.tls|.CRT|.bss|.chks64|.drectve|.rtc|.voltbl|.comment|.gfids|.eh_fram|.rsrc$|.stab"
    
    if ($dependencies) {
        $dependencyList = ($dependencies -join '<br>')
    } else {
        $dependencyList = "No external dependencies found"
    }
    
    # Append to HTML Report
    $reportContent += "<tr><td>$exe</td><td>$dependencyList</td></tr>"
}

# Include Links to Build Files
$reportContent += "</table>
<h3>Additional Developer Information</h3>
<ul>
<li><a href='$msbuildLog'>MSBuild Log</a></li>
<li><a href='$cmakeLists'>CMakeLists.txt</a></li>
<li><a href='$gitStatusLog'>Git Status Log</a></li>
<li><a href='$systemInfoLog'>System Info Log</a></li>
</ul>
</body></html>"

$reportContent | Out-File -FilePath $htmlReport -Encoding utf8

# Exit Banner
Write-Output "======================================"
Write-Output " Analysis Complete - Report Generated: $htmlReport "
Write-Output " Log File: $logFile "
Write-Output "======================================"
