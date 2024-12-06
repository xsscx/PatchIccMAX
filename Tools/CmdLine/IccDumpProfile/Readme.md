
# ICC Dump Profile Tool

## Overview
This tool parses and displays the contents of ICC profiles, providing detailed information about headers, tags, and their structures. It also validates profiles against ICC specifications and supports verbosity levels for detailed output.

---

## Features
- Parses ICC profiles and displays header and tag information.
- Validates profiles for compliance with ICC standards.
- Supports verbosity levels (1–100) for tailored output.
- Displays detailed information about individual tags or all tags in the profile.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - ICC Profile Library (`IccProfLib`) v2.0 or later.
  - Standard C++ libraries.

### Input Requirements
1. **ICC Profiles:** Must conform to ICC specifications.

---

## Usage

### Command
```bash
iccDumpProfile {-v} {verbosity} <profile_path> {tagId/"ALL"}
```

### Parameters
1. **`-v` (Optional):** Enables validation mode.
2. **`verbosity` (Optional):** Integer between 1 (minimum output) and 100 (maximum output). Defaults to 100.
3. **`<profile_path>`:** Path to the ICC profile to parse.
4. **`{tagId/"ALL"}` (Optional):** Specify a tag to display or `ALL` for all tags.

### Examples
1. **Display all tags in a profile:**
   ```bash
   iccDumpProfile example.icc ALL
   ```
2. **Validate a profile with maximum verbosity:**
   ```bash
   iccDumpProfile -v 100 example.icc
   ```
3. **Display a specific tag:**
   ```bash
   iccDumpProfile example.icc icSigAToB0Tag
   ```

---

## Notes

### Validation
- Validates profile headers and tag structures against ICC.1 and ICC.2 specifications.
- Reports warnings, non-compliances, or critical errors.

### Verbosity Levels
- Adjust the output detail using verbosity levels (1–100).

### Tag Information
- Displays tag types, offsets, sizes, and padding details.
- Dumps content for specified tags or all tags in the profile.

### Memory Leak Detection (Optional)
- Enable memory leak checking during development using the `MEMORY_LEAK_CHECK` define.

---

## Compliance

This tool adheres to **ICC.1:2022** and **ICC.2:2019** standards for profile parsing and validation.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.
