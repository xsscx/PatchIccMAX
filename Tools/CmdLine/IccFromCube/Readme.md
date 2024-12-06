
# ICC From Cube Tool

## Overview
This tool converts a 3D LUT `.cube` file into an **ICC.2 device link profile**, enabling seamless integration into ICC-based color workflows. It supports parsing of 3D LUT headers, custom input ranges, and metadata like titles and comments.

---

## Features
- Parses 3D LUT `.cube` files and extracts color transformation data.
- Creates ICC.2 device link profiles with embedded 3D LUT data.
- Supports custom input ranges for flexibility in color management.
- Preserves metadata like titles and comments from `.cube` files.

---

## Usage

### Command
```bash
iccFromCube <cube_file> <output_icc_file>
```

### Parameters
1. **`<cube_file>`:** Path to the input `.cube` file.
2. **`<output_icc_file>`:** Path to save the generated ICC.2 device link profile.

### Examples
1. **Convert a Cube File to ICC:**
   ```bash
   iccFromCube example.cube output.icc
   ```

---

## Notes

### Cube File Parsing
- Reads `.cube` file headers and extracts:
  - Title and comments.
  - LUT size and input range specifications.
- Supports custom input ranges via `DOMAIN_MIN` and `DOMAIN_MAX`.

### ICC Profile Generation
1. **Header Initialization:**
   - Sets device class to `Link`.
   - Configures color space and PCS as RGB.
2. **LUT Embedding:**
   - Converts 3D LUT data into ICC-compatible multi-process element tags.
3. **Metadata Preservation:**
   - Transfers title and comments into profile description and copyright tags.

### Error Handling
- Validates `.cube` file structure and reports parsing errors.
- Ensures LUT size matches specified dimensions.

---


## Compliance

This tool adheres to **ICC.2:2023** standards for device link profile creation.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
