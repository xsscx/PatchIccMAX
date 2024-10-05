#!/bin/zsh
#
# Development Branch Build Script for XNU
# Refactor Date: 30-Sept-2024
# Author: David Hoyt
# Purpose: Automates the build and testing for the development branch
#
# ============================================================

echo "PatchIccMAX Development Branch Build Script for XNU"
echo "Written by David Hoyt for DemoIccMAX Project"
echo "Last Updated: 1415 on 30-Sept-2024"

# Initialize log file with a timestamp for tracking
LOGFILE="build_log_$(date +%Y-%m-%d_%H-%M-%S).log"
START_TIME=$(date +%s)

# Function to print colored banners to improve readability in the terminal
print_banner() {
    echo "\033[1;34m============================================================"
    echo " $1"
    echo " Time: $(date)"
    echo "============================================================\033[0m"
}

# Function to run a command and log both output and errors to the console and logfile
run_and_log() {
    echo "\033[1;33mRunning command: $@\033[0m" | tee -a "$LOGFILE"
    "$@" 2>&1 | tee -a "$LOGFILE"
    # Check if command was successful, else exit with error message
    if [[ $? -ne 0 ]]; then
        echo "\033[1;31mError encountered during: $@. Exiting...\033[0m" | tee -a "$LOGFILE"
        exit 1
    fi
}

# Function to display total script run time at the end
print_elapsed_time() {
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo "Elapsed Time: $(date -u -r $ELAPSED_TIME +'%H:%M:%S')" | tee -a "$LOGFILE"
}

# ------------------------------ SCRIPT START ------------------------------
print_banner "Development Branch Build Script Initiated"

# Step 1: Configure Git user settings for this session
print_banner "Step 1: Configuring Git User"
run_and_log git config --global user.email "github-actions@github.com"
run_and_log git config --global user.name "GitHub Actions"

# Step 2: Clone the development branch of the repository
print_banner "Step 2: Cloning Development Branch"
run_and_log git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX/ || exit

# Step 3: Checkout the development branch
print_banner "Step 3: Checking out Development Branch"
run_and_log git checkout development

# Step 4: Navigate to the build directory
print_banner "Step 4: Navigating to Build Directory"
cd Build/ || exit

# Step 5: Configure the build with CMake
print_banner "Step 5: Configuring Build with CMake"
run_and_log cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev Cmake/

# Step 6: Build the project using 'make' with reduced output noise
print_banner "Step 6: Building the Code (Quiet Mode)"
run_and_log make -j$(sysctl -n hw.ncpu) 2>&1 | tee build_output.log | grep -i 'silent_mode'

# Step 7: Run CreateAllProfiles test suite and log results
print_banner "Step 7: Running CreateAllProfiles Test Suite"
cd ../Testing || exit
run_and_log /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/CreateAllProfiles.sh)" > CreateAllProfiles.log
run_and_log echo "Showing last 15 lines of CreateAllProfiles.log:"
run_and_log tail -n 15 CreateAllProfiles.log

# Step 8: Run allocator mismatch check for iccApplyNamedCmm
print_banner "Step 8: Running iccApplyNamedCmm Allocator Mismatch Check"
run_and_log /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh)" > asan-checks.log
run_and_log tail -n 50 asan-checks.log

# Step 9: Run UBSan icPlatformSignature check
print_banner "Step 9: Running UBSan icPlatformSignature Check"
run_and_log curl -fsSL -o iccProfile.icc https://github.com/xsscx/PatchIccMAX/raw/development/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc
run_and_log ../Build/Tools/IccDumpProfile/iccDumpProfile 100 iccProfile.icc ALL

# Step 10: Perform vulnerability check for CVE-2023-46602
print_banner "Step 10: Running CVE-2023-46602 Vulnerability Check"
run_and_log ../Build/Tools/IccToXml/iccToXml ../contrib/UnitTest/cve-2023-46602.icc ../contrib/UnitTest/cve-2023-46602.xml

# Step 11: Check for ubsan icSigMatrixElemType-Read issues
print_banner "Step 11: Running ubsan icSigMatrixElemType-Read Check"
cd ../contrib/UnitTest/
run_and_log wget https://github.com/xsscx/PatchIccMAX/raw/refs/heads/development/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc
run_and_log /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/icSigMatrixElemType-Read-poc.sh)"
cd ../../Testing

# Step 12: Execute all tests and summarize the logs
print_banner "Step 12: Running All Tests"
run_and_log zsh run_all_tests.sh > profile-checks.log
run_and_log tail -n 50 profile-checks.log
print_banner "Logs are located in Testing/"
pwd
ls -la *.log

# Final log and summary
print_banner "All steps completed successfully. Logs available in the Testing/ directory."
print_elapsed_time
