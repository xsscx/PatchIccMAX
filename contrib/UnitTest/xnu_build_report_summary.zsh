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

log_file="binary_analysis_$(date +%Y%m%d_%H%M%S).log"
echo "Binary Analysis Report - $(date)" > "$log_file"

# Log function
log_message() {
    echo "$(date): $1" | tee -a "$log_file"
}

# Process each file and classify
log_message "Starting binary analysis for ./Tools, ./IccXML, and ./IccProfLib"

while IFS= read -r line; do
    binary=$(echo "$line" | awk -F: '{print $1}')
    file_type=$(echo "$line" | awk -F: '{print $2}')

    ((total_files++))

    if echo "$file_type" | grep -q "executable"; then
        executables+=("$binary")
        ((executables_count++))
    elif echo "$file_type" | grep -q "dynamically linked shared library"; then
        dynamic_libs+=("$binary")
        ((dynamic_libs_count++))
    elif echo "$file_type" | grep -q "current ar archive"; then
        static_libs+=("$binary")
        ((static_libs_count++))
    fi
done < <(find ./Tools ./IccXML ./IccProfLib -type f \( -path './bin-temp' -o -path './CMakeFiles' \) -prune -o -perm +111 -exec file {} \; | grep -i "Mach-O" | grep -vE './bin-temp|./CMakeFiles')

# Generate summary
log_message ""
log_message "Summary Report"
log_message "--------------"
log_message "Total Mach-O Files: $total_files"
log_message "Executables Found: $executables_count"
log_message "Dynamic Libraries Found: $dynamic_libs_count"
log_message "Static Libraries Found: $static_libs_count"

if ((executables_count > 0)); then
    log_message "List of Executables:"
    for exe in "${executables[@]}"; do
        log_message "  $exe"
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
    for static in "${static_libs[@]}"; do
        log_message "  $static"
    done
fi

log_message "Link List of Dynamic Libraries:"

find IccProfLib IccXML Tools -type f \( -name '*.dylib' -o -name '*.a' -o -perm +111 \) -exec sh -c 'file="{}";printf "File: %s\nType: %s\nDeps:\n%s\n\n" "$file" "$(file "$file")" "$(otool -L "$file" 2>/dev/null | sed "1d" | awk '\''{print "    " $0}'\'')"' \;

log_message "Build Project, Profiles and Report. Logs written to $log_file."
