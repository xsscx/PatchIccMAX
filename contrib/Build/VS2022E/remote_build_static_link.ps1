# Function to log messages with color for better UI/UX
function LogMessage {
    param (
        [string]$message,
        [string]$type = "INFO"  # Default type is INFO
    )
    
    switch ($type) {
        "INFO" {
            Write-Host "INFO: $message" -ForegroundColor Green
        }
        "ERROR" {
            Write-Host "ERROR: $message" -ForegroundColor Red
        }
        "WARNING" {
            Write-Host "WARNING: $message" -ForegroundColor Yellow
        }
        "PASS" {
            Write-Host "PASS: $message" -ForegroundColor Green
        }
        "FAIL" {
            Write-Host "FAIL: $message" -ForegroundColor Red
        }
    }
}

# Step 1: Create the 'testing' directory if it doesn't already exist
LogMessage "Step 1: Creating directory 'C:\\testing'..."
if (-Not (Test-Path -Path "C:\testing")) {
    try {
        mkdir C:\testing
        LogMessage "Directory 'C:\\testing' created successfully." "PASS"
    } catch {
        LogMessage "Failed to create directory 'C:\\testing'." "ERROR"
        exit 1
    }
} else {
    LogMessage "Directory 'C:\\testing' already exists." "INFO"
}

# Step 2: Navigate to the 'testing' directory
LogMessage "Step 2: Navigating to 'C:\\testing' directory..."
try {
    Set-Location "C:\testing"
    LogMessage "Successfully navigated to 'C:\\testing' directory." "PASS"
} catch {
    LogMessage "Failed to change directory to 'C:\\testing'." "ERROR"
    exit 1
}

# Step 3: Clone the vcpkg repository
LogMessage "Step 3: Cloning vcpkg repository from GitHub..."
if (-Not (Test-Path -Path "C:\testing\vcpkg")) {
    if (git clone https://github.com/microsoft/vcpkg.git) {
        LogMessage "vcpkg repository cloned successfully." "PASS"
    } else {
        LogMessage "Failed to clone vcpkg repository." "ERROR"
        exit 1
    }
} else {
    LogMessage "vcpkg repository already exists. Skipping clone." "INFO"
}

# Additional check for vcpkg directory
if (-Not (Test-Path -Path "C:\testing\vcpkg")) {
    LogMessage "ERROR: The vcpkg directory does not exist even after clone operation. Exiting." "ERROR"
    exit 1
}

# Step 4: Navigate to the 'vcpkg' directory
LogMessage "Step 4: Navigating to 'vcpkg' directory..."
try {
    Set-Location "C:\testing\vcpkg"
    LogMessage "Successfully navigated to 'vcpkg' directory." "PASS"
} catch {
    LogMessage "Failed to change directory to 'vcpkg'." "ERROR"
    exit 1
}

# Step 5: Bootstrap vcpkg
LogMessage "Step 5: Bootstrapping vcpkg..."
try {
    & .\bootstrap-vcpkg.bat
    LogMessage "vcpkg bootstrapped successfully." "PASS"
} catch {
    LogMessage "Failed to bootstrap vcpkg." "ERROR"
    exit 1
}

# Step 6: Integrate vcpkg with the system
LogMessage "Step 6: Integrating vcpkg with the system..."
try {
    & .\vcpkg.exe integrate install
    LogMessage "vcpkg integration completed successfully." "PASS"
} catch {
    LogMessage "Failed to integrate vcpkg with the system." "ERROR"
    exit 1
}

# Step 7: Install required libraries
$libraries = @("libxml2:x64-windows", "tiff:x64-windows", "wxwidgets:x64-windows", "libxml2:x64-windows-static", "tiff:x64-windows-static", "wxwidgets:x64-windows-static")
LogMessage "Step 7: Installing required libraries..."
foreach ($library in $libraries) {
    LogMessage "Installing $library..."
    try {
        & .\vcpkg.exe install $library
        LogMessage "$library installed successfully." "PASS"
    } catch {
        LogMessage "Failed to install $library." "ERROR"
        exit 1
    }
}

# Step 8: Navigate back to the 'testing' directory
LogMessage "Step 8: Returning to 'C:\\testing' directory..."
try {
    Set-Location "C:\testing"
    LogMessage "Successfully returned to 'C:\\testing' directory." "PASS"
} catch {
    LogMessage "Failed to return to 'C:\\testing' directory." "ERROR"
    exit 1
}

# Step 9: Clone the PatchIccMAX repository from GitHub if not already cloned
LogMessage "Step 9: Cloning PatchIccMAX repository from GitHub..."
if (-Not (Test-Path -Path "C:\testing\PatchIccMAX")) {
    if (git clone https://github.com/xsscx/PatchIccMAX.git) {
        LogMessage "PatchIccMAX repository cloned successfully." "PASS"
    } else {
        LogMessage "Failed to clone PatchIccMAX repository." "ERROR"
        exit 1
    }
} else {
    LogMessage "PatchIccMAX repository already exists. Skipping clone." "INFO"
}

# Step 10: Navigate to the PatchIccMAX directory
LogMessage "Step 10: Navigating to 'PatchIccMAX' directory..."
try {
    Set-Location "C:\testing\PatchIccMAX"
    LogMessage "Successfully navigated to 'PatchIccMAX' directory." "PASS"
} catch {
    LogMessage "Failed to change directory to 'PatchIccMAX'." "ERROR"
    exit 1
}

# Step 11: Checkout the 'static' branch
LogMessage "Step 11: Checking out the 'static' branch..."
if (git checkout static) {
    LogMessage "Successfully checked out the 'static' branch." "PASS"
} else {
    LogMessage "Failed to checkout the 'static' branch." "ERROR"
    exit 1
}

LogMessage "Script execution completed successfully. Ready for building!" "PASS"
