#!/bin/sh
##
## Unit Test for PR105 Build Check
## 
##
## David Hoyt for DemoIccMAX Project
## Date: 22-NOV-24
##

# Define log file
LOGFILE="build_log_$(date +%Y-%m-%d_%H-%M-%S).log"
START_TIME=$(date +%s)

# Function to print section banners
print_banner() {
    echo "============================================================"
    echo " $1"
    echo " Time: $(date)"
    echo "============================================================"
}

# Function to log both stdout and stderr, and also show in real-time
run_and_log() {
    "$@" 2>&1 | tee -a $LOGFILE
}

# Function to track elapsed time
print_elapsed_time() {
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo "Elapsed Time: $(date -ud "@$ELAPSED_TIME" +'%H:%M:%S')"
}

# Start Script
print_banner "PR105 Build Script now running.."
run_and_log echo "Logfile: $LOGFILE"

# Step 0: Install Deps
print_banner "PR105 Installing Deps that required sudo.."
run_and_log echo "sudo apt install nlohmann-json3-dev curl git make cmake clang clang-tools libwxgtk-media3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libwxgtk3.0-gtk3-dev libwxgtk-media3.0-gtk3 libwxgtk-webview3.0-gtk3 libwxgtk3.0-gtk3 libxml2 libtiff5 libxml2-dev libtiff5-dev make cmake build-essential"

# Step 1: Configuring Git user
print_banner "Step 1: Configuring Git user for this session"
run_and_log git config --global user.email "github-actions@github.com" || { echo "Error: Git config failed. Exiting."; exit 1; }
run_and_log git config --global user.name "GitHub Actions" || { echo "Error: Git config failed. Exiting."; exit 1; }
run_and_log echo "Git user configuration done."

# Step 2: Cloning PR105
print_banner "Step 2: Cloning PR105"
run_and_log git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git || { echo "Error: Git clone failed. Exiting."; exit 1; }
cd DemoIccMAX/ || { echo "Error: Failed to change directory to PatchIccMAX. Exiting."; exit 1; }
run_and_log echo "Repository cloned and switched to DemoIccMAX directory."

# Step 3: Checking out PR105
print_banner "Step 3: Checking out PR105"
run_and_log git fetch origin pull/105/head:pr-105 || { echo "Error: Git Fetch failed. Exiting."; exit 1; }
run_and_log git checkout pr-105 || { echo "Error: Git checkout PR105 failed. Exiting."; exit 1; }
run_and_log echo "PR105 checked out."

# Step 4: Changing to Build directory
print_banner "Step 4: Changing to Build directory"
cd Build/ || { echo "Error: Directory change to Build/ failed. Exiting."; exit 1; }
run_and_log echo "Changed to Build directory."

# Step 5: Configuring the build with CMake
print_banner "Step 5: Configuring the build with CMake"
run_and_log cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev Cmake/ || { echo "Error: CMake configuration failed. Exiting."; exit 1; }
run_and_log echo "CMake configuration completed."

# Step 6: Building the code with make
print_banner "Step 6: Building the code with make"
run_and_log make -j$(nproc) || { echo "Error: Build failed. Exiting."; exit 1; }
run_and_log echo "Build completed successfully."

# Final Message
print_banner "PR105 - All steps completed successfully, Build Errors will be shown above...."
run_and_log echo "Based on https://github.com/InternationalColorConsortium/DemoIccMAX/pull/105"

# Print total elapsed time
print_elapsed_time
