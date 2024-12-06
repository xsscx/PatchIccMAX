
# ICC Apply To Link Tool

## Overview
This tool applies a sequence of ICC profiles to create a link, generating either a device link profile or a 3D LUT `.cube` file. It enables advanced transformations and workflow customization using environment variables, rendering intents, and Profile Connection Conditions (PCCs).

---

## Features
- Creates device link profiles (ICC v4 or ICC v5).
- Generates 3D LUTs in `.cube` format for use in color grading workflows.
- Supports customization of LUT sizes and input ranges.
- Handles spectral workflows with PCCs and supports advanced rendering intents.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - ICC Profile Library (`IccProfLib`) v2.0 or later.
  - Standard C++ libraries.

### Input Requirements
1. **ICC Profiles:** Must conform to ICC specifications.
2. **Profile Sequence:** Profiles provided in the correct order for transformation.

---

## Usage

### Command
```bash
iccApplyToLink <dst_link_file> <link_type> <lut_size> <option> <title> <range_min> <range_max> <first_transform> <interp> {{-ENV:sig value} <profile_file_path> <rendering_intent> {-PCC <connection_conditions_path>}}
```

### Parameters
1. **dst_link_file:** Output file path for the generated link.
2. **link_type:**
   - `0`: Device Link Profile.
   - `1`: 3D LUT `.cube` file.
3. **lut_size:** Number of grid entries for each LUT dimension.
4. **option:**
   - If `link_type` is `0`: Precision for LUT in `.cube` files.
   - If `link_type` is `1`: `0` for ICC v4, `1` for ICC v5.
5. **title:** Title or description for the output file.
6. **range_min / range_max:** Input range for the source data.
7. **first_transform:** `0` for source transform, `1` for destination transform.
8. **interp:**
   - `0`: Linear interpolation.
   - `1`: Tetrahedral interpolation.
9. **profile_file_path:** Paths to ICC profiles to include in the link.
10. **rendering_intent:** Specifies rendering intent (see technical notes).

### Example
1. **Device Link Profile:**
   ```bash
   iccApplyToLink output.icc 0 33 1 "Device Link Profile" 0.0 1.0 1 0 profile1.icc 0 profile2.icc 1
   ```
2. **3D LUT Cube File:**
   ```bash
   iccApplyToLink output.cube 1 17 4 "3D LUT Example" 0.0 1.0 0 1 profile1.icc 2
   ```

---

## Notes

### LUT Customization
- **Size:** Controlled by `lut_size`, determining granularity.
- **Precision:** Specified for `.cube` files.

### Rendering Intent Codes
- `0`: Perceptual.
- `1`: Relative.
- `2`: Saturation.
- `3`: Absolute.
- `10+`: Custom options like BPC, luminance adjustments, or spectral workflows.

### Output Types
- **Device Link Profile:** For use in ICC-compatible workflows.
- **3D LUT Cube:** For use in video and image editing tools.

---

## Compliance

This tool adheres to **ICC.2:2023** standards for color profile linking and transformation.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
