
# ICC Spectral Separation to TIFF Tool

## Overview
This tool concatenates several separated spectral TIFF files into a single TIFF file, with an option to embed an ICC profile. It is designed to streamline spectral imaging workflows and support high-precision spectral data manipulation.

---

## Features
- Merges multiple spectral separation TIFF files into one.
- Supports embedding ICC profiles into the output file.
- Handles various compression and photometric interpretation flags.
- Validates input files for consistency.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - ICC Profile Library (`IccProfLib`) v2.0 or later.
  - TIFF library for handling image files.
  - Standard C++ libraries.

### Input Requirements
1. **Spectral TIFF Files:** Must share consistent formats (e.g., resolution, dimensions).
2. **Output Path:** Destination for the combined TIFF file.

---

## Usage

### Command
```bash
iccSpecSepToTiff <output_file> <compress_flag> <sep_flag> <infile_fmt_file> <start_nm> <end_nm> <inc_nm> [embedded_icc_profile_file]
```

### Parameters
1. **`output_file:`** Path to the combined TIFF file.
2. **`compress_flag:`** Enables compression (`1`) or disables it (`0`).
3. **`sep_flag:`** Treats files as separations (`1`) or disables this (`0`).
4. **`infile_fmt_file:`** Format string for input TIFF files (e.g., `file_%d.tiff`).
5. **`start_nm / end_nm / inc_nm:`** Wavelength range (start, end, increment).
6. **`embedded_icc_profile_file` (Optional):** Path to an ICC profile for embedding.

### Examples
1. **Combine Spectral Files Without ICC:**
   ```bash
   iccSpecSepToTiff output.tiff 1 1 "sep_file_%d.tiff" 400 700 10
   ```
2. **Combine and Embed ICC Profile:**
   ```bash
   iccSpecSepToTiff output.tiff 1 1 "sep_file_%d.tiff" 400 700 10 profile.icc
   ```

---

## Notes

### Validation and Compatibility
- Input files must have consistent dimensions, bit depths, and photometric interpretations.
- Outputs MinIsBlack TIFF files by default.

### Embedding ICC Profiles
- Supports embedding ICC profiles for color management workflows.

### Compression
- Enabled by setting the `compress_flag` to `1`.

### Error Handling
- Validates input file formats and reports inconsistencies.

---

## Compliance

This tool adheres to **ICC.2:2023** and TIFF standards for spectral data processing.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
