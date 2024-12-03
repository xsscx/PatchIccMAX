#!/bin/zsh
#
# Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
#
# Last Updated: 10-FEB-2025 by David Hoyt | h02332
#
# Intent:
#   This script polls the macOS device, retrieves system and development environment
#   details, and reports key security and developer-related configurations.
#
# Features:
#   - Reports macOS kernel, OS, and CPU details
#   - Checks for developer toolchain versions and paths
#   - Examines environmental variables relevant to development
#   - Identifies system integrity protection (SIP) status
#   - Lists installed Homebrew packages
#   - Reports system disk usage and important binaries
#
# Usage:
#   Run this script in a terminal with:
#     ./device_report.zsh
#

### System Information ###
echo "\n### macOS System Information ###"
sysctl kern.version
sysctl kern.osversion
sysctl kern.iossupportversion 2>/dev/null  # Only available on macOS supporting iOS apps
sysctl kern.osproductversion
sysctl machdep.cpu.brand_string

### Security & Integrity Checks ###
echo "\n### Security Configuration ###"
csrutil status  # Check System Integrity Protection (SIP) status
spctl --status  # Check Gatekeeper status

# Check AMFI (Apple Mobile File Integrity) status
echo "\nChecking AMFI Status..."
sudo nvram boot-args 2>/dev/null | grep amfi

# Check KEXT (Kernel Extension) Loading Capability
echo "\nChecking Kernel Extension (KEXT) Loading Capability..."
kextstat | grep -v com.apple  # Show non-Apple kernel extensions
kmutil showloaded 2>/dev/null  # macOS Big Sur and later

# Check Transparency, Consent, and Control (TCC) Database for Security Settings
echo "\nChecking TCC (Transparency, Consent, and Control) Status..."
defaults read /Library/Application\ Support/com.apple.TCC/TCC.db 2>/dev/null || echo "TCC database access requires elevated privileges."

### Developer Tools & Xcode Environment ###
echo "\n### Developer Toolchain Information ###"
xcrun --show-sdk-path
xcode-select -p
clang -v
clang -### -c /dev/null 2>&1 | grep -i 'cc1args'
ld -v
lldb --version

### Environment Variables Related to Development ###
echo "\n### Developer Environment Variables ###"
env | grep -iE "(xcode|sdk|clang|cflags|ldflags|CC|C\+\+)"

### Homebrew Installed Packages ###
echo "\n### Homebrew Installed Packages ###"
if command -v brew >/dev/null 2>&1; then
    brew list --versions
else
    echo "Homebrew is not installed."
fi

### System Binaries and Toolchain Locations ###
echo "\n### Essential System Binaries ###"
ls -l /usr/lib/dyld  # Dynamic linker location
df -h  # Disk usage
which make
which ninja
which cmake
which lldb
which cc
which gcc
which clang++
which python3
which ruby
which perl

### Miscellaneous Tools ###
echo "\n### Additional System Tools ###"

# Check if Python is installed before attempting to run LLDB
if command -v python3 >/dev/null 2>&1; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    echo "Python version detected: $PYTHON_VERSION"

    # Ensure Homebrew's Python 3.13 is installed if required
    if [[ "$PYTHON_VERSION" != "3.13"* ]]; then
        echo "Warning: LLDB may require Python 3.13. Checking Homebrew installation..."
        if ! brew list --versions | grep -q "python@3.13"; then
            echo "Python 3.13 is missing. Install it with: brew install python@3.13"
        else
            echo "Python 3.13 is installed, but not active. Try running: brew link --overwrite python@3.13"
        fi
    fi
else
    echo "Python is not installed. LLDB may fail to run."
fi

# Check if lldb is installed before running it
if command -v lldb >/dev/null 2>&1; then
    echo "Running LLDB version check..."
    lldb --version || echo "LLDB failed to run due to missing dependencies."
else
    echo "LLDB is not installed or misconfigured."
fi

# Check if sips exists before calling it
if command -v sips >/dev/null 2>&1; then
    sips --version  # Image processing utility
else
    echo "sips is not available."
fi

### End of Report ###
