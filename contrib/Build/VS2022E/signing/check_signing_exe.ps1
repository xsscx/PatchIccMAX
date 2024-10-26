# Variables
$SignedCount = 0
$LogFile = "E:\repos\PatchIccMAX\Testing\logfile_$(Get-Date -Format yyyyMMdd_HHmmss).log"

# Banner and timestamp
$StartTime = Get-Date
$Banner = "-----------------------------`nVerification Process Start: $($StartTime)`n-----------------------------"
Write-Host $Banner
Add-Content -Path $LogFile -Value $Banner

# Function to log both to the console and file
function Log-Message {
    param (
        [string]$Message
    )
    Write-Host $Message
    Add-Content -Path $LogFile -Value $Message
}

# Start verifying .exe files
Get-ChildItem -Path "E:\repos\PatchIccMAX\Testing" -Recurse -Filter *.exe | ForEach-Object {
    try {
        $FilePath = $_.FullName
        Log-Message "Checking file: $FilePath"
        
        # Verify signature using signtool (from PATH)
        $VerificationResult = & signtool verify /pa /v $FilePath 2>&1
        
        # Check if it's signed by "David H Hoyt LLC"
        if ($VerificationResult | Select-String -Pattern "Issued to: David H Hoyt LLC") {
            $SignedCount++
            Log-Message "SIGNED: $FilePath"
        } else {
            Log-Message "NOT SIGNED or SIGNED by another entity: $FilePath"
        }
    } catch {
        # Log the error and continue with the next file
        $ErrorMessage = $_.Exception.Message
        Log-Message ("ERROR processing file: " + $FilePath + " with message: " + $ErrorMessage)
    }
}

# Summary
$EndTime = Get-Date
$Summary = "`n-----------------------------`nProcess Complete: $($EndTime)`nNumber of files signed by David H Hoyt LLC: $SignedCount`n-----------------------------"
Log-Message $Summary

# Final output to console
Write-Host "Number of files signed by David H Hoyt LLC: $SignedCount"
