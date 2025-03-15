#!/bin/zsh
##
## Copyright (c) 2025 David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 15-MAR-2025 1351 EDT
#
# Branch: XNU
# Intent: PROTOTYPE
# Production: FALSE
# Runner: TRUE
#
#
# Updates: Added platform conditional
#          Fixed globbing
#
# Run: /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/xnu/contrib/Build/cmake/build_clang_master_branch.zsh)"
# 
#  
## Build Script using Clang for master branch

# Detect OS (macOS or Linux)
OS_TYPE="$(uname)"
if [[ "$OS_TYPE" == "Darwin" ]]; then
    PACKAGE_MANAGER="brew"
elif [[ "$OS_TYPE" == "Linux" ]]; then
    PACKAGE_MANAGER="apt-get"
else
    echo "❌ Unsupported OS: $OS_TYPE. Exiting."
    exit 1
fi

## Build Script using Clang for master branch

export CXX=clang++
export CC=clang

# Default ASAN options
export ASAN_OPTIONS="alloc_dealloc_mismatch=1:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:detect_invalid_pointer_pairs=2:halt_on_error=0:verbosity=1"

# Detect if running on macOS (Darwin) and ARM64
if [[ "$(uname -s)" == "Darwin" && "$(uname -m)" == "arm64" ]]; then
    export ASAN_OPTIONS=${ASAN_OPTIONS//detect_leaks=1/detect_leaks=0}
fi

# Log the ASAN_OPTIONS value
echo "ASAN_OPTIONS is set to: $ASAN_OPTIONS" >> asan_options.log

# Define log file
LOGFILE="build_log_$(date +%Y-%m-%d_%H-%M-%S).log"
START_TIME=$(date +%s)

# Set compiler to Clang explicitly for B testing
COMPILER="clang++"
CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall"

# Function to print section banners
print_banner() {
    echo "============================================================"
    echo " $1"
    echo " Time: $(date)"
    echo "============================================================"
}

# Function to log both stdout and stderr, and also show in real-time
run_and_log() {
    "$@" 2>&1 | tee -a "$LOGFILE"
}

print_elapsed_time() {
    local END_TIME=$(date +%s)
    local ELAPSED_TIME=$((END_TIME - START_TIME))

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS-compatible elapsed time formatting
        local HH=$((ELAPSED_TIME / 3600))
        local MM=$(((ELAPSED_TIME % 3600) / 60))
        local SS=$((ELAPSED_TIME % 60))
        printf "Elapsed Time: %02d:%02d:%02d\n" $HH $MM $SS
    else
        # Linux (GNU date) version
        echo "Elapsed Time: $(date -ud "@$ELAPSED_TIME" +'%H:%M:%S')"
    fi
}

# Start Script
print_banner "David H Hoyt LLC | PatchIccMAX Project | Clang Build"
print_banner "For more information see srd.cx"
print_banner "Build Script now running with compiler: $COMPILER"
run_and_log echo "Logfile: $LOGFILE"

# Step 1: Configuring Git user
print_banner "Step 1: Configuring Git user for this session"
run_and_log git config --global user.email "github-actions@github.com"
run_and_log git config --global user.name "GitHub Actions"
run_and_log echo "✅ Git user configuration done."

# Step 2: Cloning master branch
print_banner "Step 2: Cloning DemoIccMAX on master branch"
run_and_log git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/ || { echo "❌ Error: Failed to change directory to DemoIccMAX. Exiting."; exit 1; }
run_and_log echo "✅ Repository cloned and switched to DemoIccMAX directory."

# Step 3: Installing Dependencies, with conflict resolution
print_banner "Step 3: Installing Dependencies, you may be prompted for sudo password."

if [[ "$OS_TYPE" == "Linux" ]]; then
    echo "🛠️ Removing potentially conflicting packages..."
    sudo apt-get remove -y libopencl-clang-* python3-clang-* || echo "⚠️ Warning: Some packages were not found."

    echo "🔄 Updating package list and fixing broken packages..."
    sudo apt-get update && sudo apt-get --fix-broken install

    echo "📦 Installing necessary dependencies..."
    sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev \
    libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl \
    git make cmake clang clang-tools libxml2 libxml2-dev \
    nlohmann-json3-dev build-essential
elif [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "📦 Installing necessary dependencies using Homebrew..."
    brew install wxwidgets libtiff curl git cmake clang llvm nlohmann-json
fi

echo "✅ Dependencies installed successfully."

# Step 4: Build with Clang
print_banner "Step 4: Starting Build using $COMPILER...."
mkdir -p Build && cd Build/

print_banner "Step 5: Configuring CMake with $COMPILER"
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_CXX_COMPILER="$COMPILER" -DCMAKE_CXX_FLAGS="$CXX_FLAGS" \
-DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON \
-Wno-dev Cmake/ || { echo "❌ Error: CMake configuration failed. Exiting."; exit 1; }

print_banner "Step 6: Running make (low-noise)"
make -j$(sysctl -n hw.logicalcpu 2>/dev/null || nproc) >/dev/null 2>&1 || { echo "❌ Error: Build failed. Exiting."; exit 1; }

# List built files
print_banner "Built Files:"
find . -type f \( -perm -111 -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) \
-mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -exec ls -lh {} \;

# Move to Testing directory
print_banner "Step 7: Running Tests"
cd ../Testing || { echo "❌ Error: Testing directory not found. Exiting."; exit 1; }

print_banner "Creating Profiles"
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)" || { echo "❌ Error: Profile creation failed. Exiting."; exit 1; }

print_banner "✅ Build Project and CreateAllProfiles Done!"
print_elapsed_time
