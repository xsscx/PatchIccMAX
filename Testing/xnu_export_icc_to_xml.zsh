#!/bin/zsh

# Path to the iccDumpProfile executable
ICC_DUMP_PROFILE="../Build/Tools/IccToXml/iccToXml"

# Directories to search for profiles
PROFILE_DIRS=(
    "/System/Library/ColorSync/Profiles/"
    "/Library/ColorSync/Profiles/"
    "$HOME/Library/ColorSync/Profiles/"
)

# Output directory
OUTPUT_DIR="xnuiccprofiles"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through each profile directory
for dir in "${PROFILE_DIRS[@]}"; do
    # Check if the directory exists
    if [ -d "$dir" ]; then
        # Find all .icc files in the directory and process each
        find "$dir" -name "*.icc" -print0 | while IFS= read -r -d '' profile; do
            # Extract the profile name (without path)
            profile_name=$(basename "$profile" .icc | tr -cd '[:alnum:]_.')

            # Run iccDumpProfile and save the output to a .xml file (correcting argument order)
            "$ICC_DUMP_PROFILE" "$profile" "$OUTPUT_DIR/$profile_name.xml"

            # Confirm the result
            echo "Processed: $profile"
            echo "Output saved to: $OUTPUT_DIR/$profile_name.xml"
        done
    else
        echo "Directory not found: $dir"
    fi
done

echo "All profiles have been processed."
