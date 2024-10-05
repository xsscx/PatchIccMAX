# Initialize counters
$total_xml = 0
$total_icc = 0
$failed_files = 0

# File to store the report
$report_file = "creation_report.txt"

# Ensure the report file exists (create if not)
if (-not (Test-Path $report_file)) {
    New-Item -Path $report_file -ItemType File | Out-Null
}

# Clear the report file at the start
Clear-Content -Path $report_file

# Log banner function for reporting
function Log-Banner {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $banner = "=" * 50
    $log = "[$timestamp] $message"
    $banner | Tee-Object -FilePath $report_file -Append
    $log | Tee-Object -FilePath $report_file -Append
    $banner | Tee-Object -FilePath $report_file -Append
}

# Function to get all XML and ICC files, excluding certain directories
function Find-Files {
    $exclude_dirs = @(".\xnuiccprofiles") # Directories to exclude
    $files = Get-ChildItem -Recurse -File -Include *.xml, *.icc | Where-Object {
        $exclude_dirs -notcontains $_.DirectoryName
    }
    return $files
}

# Start logging
Log-Banner "Starting XML to ICC correlation analysis"

# Create lists to track XML and ICC file base names
$xml_list = @()
$icc_list = @()

# Traverse the directory and find XML and ICC files excluding certain directories
$files = Find-Files
foreach ($file in $files) {
    $base_name = [System.IO.Path]::GetFileNameWithoutExtension($file.FullName)

    if ($file.Extension -eq ".xml") {
        $total_xml++
        $xml_list += $base_name
    } elseif ($file.Extension -eq ".icc") {
        $total_icc++
        $icc_list += $base_name
    }
}

# Sort the lists
$xml_list = $xml_list | Sort-Object
$icc_list = $icc_list | Sort-Object

# List and count XML files without a corresponding ICC
Log-Banner "Identifying non-creations (XML files without corresponding ICC files)"
foreach ($xml_file in $xml_list) {
    if (-not ($icc_list -contains $xml_file)) {
        "Non-creation: $xml_file.xml" | Tee-Object -FilePath $report_file -Append
        $failed_files++
    }
}

# Summary report
Log-Banner "Summary Report"
"Total XML files: $total_xml" | Tee-Object -FilePath $report_file -Append
"Total ICC files: $total_icc" | Tee-Object -FilePath $report_file -Append
"Total successful creations (matched XML and ICC): $($total_xml - $failed_files)" | Tee-Object -FilePath $report_file -Append
"Total non-creation (XML without ICC): $failed_files" | Tee-Object -FilePath $report_file -Append

# End of script
Log-Banner "Analysis completed"
