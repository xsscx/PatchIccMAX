#!/bin/sh

# Initialize counters
total_xml=0
total_icc=0
failed_files=0

# File to store the report
report_file="creation_report.txt"

# Directories to exclude
EXCLUDE_DIRS="./xnuiccprofiles"

# Clear report file at the start
: > "$report_file"  # Correct way to empty the file

# Log banner function for reporting
log_banner() {
  echo "==================================================" | tee -a "$report_file"
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$report_file"
  echo "==================================================" | tee -a "$report_file"
}

# Function to construct the 'find' command excluding the specified directories
find_with_excludes() {
  find_command="find . -type f \( -name '*.xml' -o -name '*.icc' \)"

  # Add excluded directories to the find command
  for exclude_dir in $EXCLUDE_DIRS; do
    find_command="$find_command -not -path '$exclude_dir/*'"
  done

  # Execute the constructed find command
  eval "$find_command"
}

# Start logging
log_banner "Starting XML to ICC correlation analysis"

# Create associative arrays to track XML and ICC file pairs
xml_map=$(mktemp)  # Temporary file to store xml map
icc_map=$(mktemp)  # Temporary file to store icc map

# Traverse the directory and find XML and ICC files excluding certain directories
for file in $(find_with_excludes); do
    # Check if it's an XML file
    case "$file" in
      *.xml)
        total_xml=$((total_xml + 1))
        # Remove the file extension to create the base filename for comparison
        base_name="${file%.xml}"
        echo "$base_name" >> "$xml_map"
        ;;
      *.icc)
        total_icc=$((total_icc + 1))
        # Remove the file extension to create the base filename for comparison
        base_name="${file%.icc}"
        echo "$base_name" >> "$icc_map"
        ;;
    esac
done

# Sort the maps
sort "$xml_map" -o "$xml_map"
sort "$icc_map" -o "$icc_map"

# List and count files that have an XML but no corresponding ICC
log_banner "Identifying non-creations (XML files without corresponding ICC files)"
while read -r base_name; do
    if ! grep -q "^$base_name$" "$icc_map"; then
        echo "Non-creation: $base_name.xml" | tee -a "$report_file"
        failed_files=$((failed_files + 1))
    fi
done < "$xml_map"

# Summary report
log_banner "Summary Report"
echo "Total XML files: $total_xml" | tee -a "$report_file"
echo "Total ICC files: $total_icc" | tee -a "$report_file"
echo "Total successful creations (matched XML and ICC): $((total_xml - failed_files))" | tee -a "$report_file"
echo "Total non-creation (XML without ICC): $failed_files" | tee -a "$report_file"

# End of script
log_banner "Analysis completed"

# Clean up temporary files
rm "$xml_map" "$icc_map"
