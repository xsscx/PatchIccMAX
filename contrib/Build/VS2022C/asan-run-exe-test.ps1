# ========================== Windows ASAN EXE Test Report Script ==========================
# Windows ASAN EXE Test Report
# Copyright (c) 2025 David H Hoyt LLC. All rights reserved.
# Author: David Hoyt
# Date: 25-FEB-2025 1552 EST
#
# Intent: Test if the x64-debug-asan triple ran after build and report Pass or Fail
#
# Use a Developer Powershell Terminal
# To be run from DemoIccMAX/
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/msvc/contrib/Build/VS2022C/asan-run-exe-test.ps1").Content
#
# ============================================================

# Start of Script
Write-Host "============================= Starting Windows Build Report =============================" -ForegroundColor Green
Write-Host "Copyright (c) 2025 David H Hoyt LLC. All rights reserved." -ForegroundColor Green
Write-Host "Last Updated: 25-FEB-2025 1552 EST by David Hoyt LLC" -ForegroundColor Green

$executables = Get-ChildItem -Path "." -Recurse -Filter *.exe
$results = @()

Write-Host "`n========== EXECUTION REPORT ==========" -ForegroundColor Green

# SECTION: Listing all executable paths
Write-Host "`n[INFO] Found $($executables.Count) executables:" -ForegroundColor Cyan
$executables | ForEach-Object { Write-Host " - $($_.FullName)" -ForegroundColor Gray }

# SECTION: Executing each EXE and capturing results
Write-Host "`n========== EXECUTING EXE FILES ==========" -ForegroundColor Green

foreach ($exe in $executables) {
    Write-Host "`nRunning: $($exe.FullName)" -ForegroundColor Cyan
    $status = "PASS"

    try {
        if ($exe.Name -match "wxProfileDump_d\.exe") {
            Start-Process explorer -ArgumentList $exe.FullName
            Write-Host "Launched GUI: $($exe.FullName)" -ForegroundColor Yellow
        } else {
            & $exe.FullName
            Write-Host "Completed CLI: $($exe.FullName)" -ForegroundColor Magenta
        }
    } catch {
        $status = "FAIL"
        Write-Host "Error: Failed to execute $($exe.FullName)" -ForegroundColor Red
    }

    $results += [PSCustomObject]@{
        Name     = $exe.Name
        Path     = $exe.FullName
        Status   = $status
        Type     = if ($exe.Name -match "wxProfileDump_d\.exe") { "GUI" } else { "CLI" }
    }
}

# SECTION: Summary Report
Write-Host "`n========== EXECUTION SUMMARY ==========" -ForegroundColor Green
Write-Host "`nTotal EXEs Processed: $($results.Count)" -ForegroundColor Cyan

$results | Format-Table Name, Type, Status -AutoSize

Write-Host "`n========== EXECUTION COMPLETE ==========" -ForegroundColor Green
