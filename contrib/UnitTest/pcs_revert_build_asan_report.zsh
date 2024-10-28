#!/bin/zsh
##
## Unit Test for PCS_Refactor Build Check for XNU
## Last Updated: 0915 EDT, 30-Sept-2024
## Author: David Hoyt from DemoIccMAX Project
## Date: 30-Sept-2024
##

echo "PCS_Refactor Branch Build Script for XNU"
echo "Written by David Hoyt for DemoIccMAX Project"
echo "Last Updated: 0915 on 30-Sept-2024"

# Define log file with timestamp (compatible with BSD/macOS)
LOGFILE="build_log_$(date '+%Y-%m-%d_%H-%M-%S').log"
START_TIME=$(date +%s)

# Function to print section banners with color formatting for better UX
print_banner() {
    echo "\033[1;34m============================================================"
    echo " $1"
    echo " Time: $(date)"
    echo "\033[1;34m============================================================\033[0m"
}

# Function to run commands with real-time logging to stdout/stderr and logfile
run_and_log() {
    echo "\033[1;33mRunning command: $@\033[0m" | tee -a "$LOGFILE"
    "$@" 2>&1 | tee -a "$LOGFILE"
    if [ $? -ne 0 ]; then
        echo "\033[1;31mError encountered during: $@. Exiting...\033[0m" | tee -a "$LOGFILE"
        exit 1
    fi
}

# Function to calculate and print the elapsed time of the script
print_elapsed_time() {
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo "Elapsed Time: $(date -u -r "$ELAPSED_TIME" +'%H:%M:%S')"  # For macOS, using -r for seconds since epoch
}

# Start of the script
print_banner "PCS_Refactor Branch Build Script Initiated (remote)"
run_and_log echo "Logfile: $LOGFILE"

# Step 1: Configuring Git user for this session
print_banner "Step 1: Configuring Git user"
run_and_log git config --global user.email "github-actions@github.com"
run_and_log git config --global user.name "GitHub Actions"

# Step 2: Cloning the development branch
print_banner "Step 2: Cloning PCS_refactor Branch"
run_and_log git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/ || { echo "Failed to enter DemoIccMAX directory"; exit 1; }
pwd
echo "Repository cloned and switched to DemoIccMAX directory."

# Step 3: Checking out the PCS_refactor branch
print_banner "Step 3: Checking out the PCS_Refactor Branch"
run_and_log git checkout PCS_Refactor
echo "PCS_Refactor branch checked out."

# Step 4: Revert commit non-interactively
print_banner "Step 4: Reverting commit b90ac3933da99179df26351c39d8d9d706ac1cc6"
run_and_log git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6

# Check if there are conflicts
if [[ $(git ls-files -u | wc -l) -gt 0 ]]; then
    echo "Conflicts found. Resolving conflicts automatically by using the current branch version."
    git ls-files -u | awk '{print $4}' | xargs git add
    echo "Continuing the revert after resolving conflicts"
    run_and_log git revert --continue --no-edit || { echo "Error: Git revert --continue failed. Exiting."; exit 1; }
else
    echo "No conflicts detected. Revert completed successfully."
fi

# Step 5: Navigating to the Build directory
print_banner "Step 5: Navigating to Build directory"
cd Build/ || { echo "Failed to enter Build directory"; exit 1; }
pwd

# Step 5: Configuring the build with CMake
print_banner "Step 5: Configuring the build with CMake"
run_and_log cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev Cmake/

# Step 6: Building the code with make (quiet mode)
print_banner "Step 6: Building the code with make (quiet mode)"
run_and_log make -j$(sysctl -n hw.ncpu) 2>&1 | tee build_output.log | grep -i 'silent_mode'
run_and_log echo "Build completed successfully."

# Step 7: Running CreateAllProfiles tests
print_banner "Step 7: Running CreateAllProfiles Tests"
cd ../Testing || { echo "Failed to enter Testing directory"; exit 1; }
run_and_log /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/CreateAllProfiles.sh)" > CreateAllProfiles.log
run_and_log echo "Tests completed. Showing last 15 lines of CreateAllProfiles.log:"
run_and_log tail -n 25 CreateAllProfiles.log

# Step 8: Running iccApplyNamedCmm allocator mismatch check
print_banner "Step 8: Running iccApplyNamedCmm Allocator Mismatch Check"
run_and_log /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh)" > asan-checks.log
run_and_log tail -n 25 asan-checks.log

# Step 9: Running UBSan icPlatformSignature check
print_banner "Step 9: Running UBSan icPlatformSignature Check"
run_and_log curl -fsSL -o iccProfile.icc https://github.com/xsscx/PatchIccMAX/raw/development/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc
run_and_log ../Build/Tools/IccDumpProfile/iccDumpProfile 100 iccProfile.icc ALL

# Step 10: Running the CVE-2023-46602 vulnerability check
print_banner "Step 10: Running CVE-2023-46602 Vulnerability Check"
run_and_log ../Build/Tools/IccToXml/iccToXml ../contrib/UnitTest/cve-2023-46602.icc ../contrib/UnitTest/cve-2023-46602.xml

# Step 11: Running UBSan icSigMatrixElemType-Read check
print_banner "Step 11: Running UBSan icSigMatrixElemType-Read Check"
cd ../contrib/UnitTest || { echo "Failed to enter contrib/UnitTest directory"; exit 1; }
run_and_log curl -fsSL -o icSigMatrixElemType-Read-poc.icc https://github.com/xsscx/PatchIccMAX/raw/refs/heads/development/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc
# run_and_log curl -fsSL https://github.com/xsscx/PatchIccMAX/raw/refs/heads/development/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc
run_and_log /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/icSigMatrixElemType-Read-poc.sh)"
cd ../../Testing || { echo "Failed to return to Testing directory"; exit 1; }
ls -lat *.log

# Final completion banner
print_banner "PCS_Refactor Branch - All steps completed successfully. Logs available in the Testing/ directory."
print_banner "Based on: https://github.com/InternationalColorConsortium/DemoIccMAX/tree/PCS_Refactor"

# Print total elapsed time
print_elapsed_time
