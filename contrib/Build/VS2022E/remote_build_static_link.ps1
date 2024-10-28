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
LogMessage "Step 1: Creating directory 'testing'..."
if (-Not (Test-Path -Path "C:\testing")) {
    try {
        mkdir C:\testing
        LogMessage "Directory 'testing' created successfully." "PASS"
    } catch {
        LogMessage "Failed to create directory 'testing'." "ERROR"
        exit 1
    }
} else {
    LogMessage "Directory 'testing' already exists." "INFO"
}

# Step 2: Navigate to the 'testing' directory
LogMessage "Step 2: Navigating to 'testing' directory..."
try {
    Set-Location "C:\testing"
    LogMessage "Successfully navigated to 'testing' directory." "PASS"
} catch {
    LogMessage "Failed to change directory to 'testing'." "ERROR"
    exit 1
}

# Step 3: Clone the vcpkg repository from GitHub
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

# Step 8: Navigate back to 'testing' directory
LogMessage "Step 8: Returning to 'testing' directory..."
try {
    Set-Location "C:\testing"
    LogMessage "Successfully returned to 'testing' directory." "PASS"
} catch {
    LogMessage "Failed to return to 'testing' directory." "ERROR"
    exit 1
}

# Step 9: Clone the PatchIccMAX repository from GitHub
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

# Step 12: Build the solution using msbuild
LogMessage "Step 12: Building the solution using msbuild..."
$msbuildCmd = "msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:CLToolAdditionalOptions='/MT /W4' /p:LinkToolAdditionalOptions='/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO' /p:PreprocessorDefinitions='STATIC_LINK' /p:RuntimeLibrary=MultiThreaded /p:AdditionalLibraryDirectories='C:\testing\vcpkg\installed\x64-windows-static\lib' /p:AdditionalDependencies='wxmsw32u_core.lib;wxbase32u.lib;%(AdditionalDependencies)' /p:LinkToolAdditionalOptions='/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO' /t:Clean,Build"

try {
    Invoke-Expression $msbuildCmd
    LogMessage "Solution built successfully." "PASS"
} catch {
    LogMessage "Failed to build the solution." "ERROR"
    exit 1
}

LogMessage "All steps completed successfully."
