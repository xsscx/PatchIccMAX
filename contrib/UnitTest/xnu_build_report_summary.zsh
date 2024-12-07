#!/bin/zsh
#
## Copyright (©) 2024 David H Hoyt. All rights reserved.
## 
## Last Updated: 02-DEC-2024 by David Hoyt (©)
#
## Intent: Create a Build Report Summary for XNU Xcode Build Outputs
#
## TODO: Refactor CMake:CMakeLists.txt Configs 
#       Refactor for CI:CD Build Pilelines Azure:Github
#       Add Logging
#       Add to Post-Build Processing in Xcode
#       Fiddle with Cmake Configuration Args
#
#

# Initialize counters and arrays
total_files=0
executables_count=0
dynamic_libs_count=0
static_libs_count=0
executables=()
dynamic_libs=()
static_libs=()
log_file="binary_summary_$(date +%Y%m%d_%H%M%S).log"

# Log function
log_message() {
    echo "$(date): $1" | tee -a "$log_file"
}

# Start processing
log_message "Starting binary analysis for ./Tools, ./IccXML, and ./IccProfLib"

# Find all relevant files
find ./Tools ./IccXML ./IccProfLib -type f \( -name "*.dylib" -o -name "*.a" -o -perm +111 \) | while read -r binary; do
    if file "$binary" | grep -q "Mach-O 64-bit executable"; then
        executables+=("$binary")
        ((executables_count++))
    elif file "$binary" | grep -q "Mach-O 64-bit dynamically linked shared library"; then
        dynamic_libs+=("$binary")
        ((dynamic_libs_count++))
    elif file "$binary" | grep -q "current ar archive"; then
        static_libs+=("$binary")
        ((static_libs_count++))
    fi
    ((total_files++))
done

# Summary
log_message ""
log_message "Summary Report"
log_message "--------------"
log_message "Total Files Found: $total_files"
log_message "Executables Found: $executables_count"
log_message "Dynamic Libraries Found: $dynamic_libs_count"
log_message "Static Libraries Found: $static_libs_count"

if ((executables_count > 0)); then
    log_message "List of Executables:"
    for executable in "${executables[@]}"; do
        log_message "  $executable"
    done
fi

if ((dynamic_libs_count > 0)); then
    log_message "List of Dynamic Libraries:"
    for dylib in "${dynamic_libs[@]}"; do
        log_message "  $dylib"
    done
fi

if ((static_libs_count > 0)); then
    log_message "List of Static Libraries:"
    for static_lib in "${static_libs[@]}"; do
        log_message "  $static_lib"
    done
fi

log_message "Build Project, Profiles and Report. Logs written to $log_file."
