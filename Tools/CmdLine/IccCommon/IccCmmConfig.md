
# ICC CMM Configuration Tool

## Overview
The ICC CMM Configuration Tool provides utilities for managing the configuration of Color Management Modules (CMM). It enables advanced control of color profiles, transformations, and workflow customization using JSON-based settings.

---

## Features
- **Profile Management:**
  - Parses and applies ICC profiles with environment variables.
  - Supports legacy and modern data formats (IT8, JSON).
- **Workflow Customization:**
  - Configures source and destination encodings, precision, and interpolation.
  - Enables spectral and BRDF workflows through extended settings.
- **Export and Import:**
  - Converts configurations to/from JSON, IT8, and legacy text formats.
  - Generates device link profiles or 3D LUTs in `.cube` format.
- **Debugging:**
  - Includes debug calculation modes and detailed logging.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - ICC Profile Library (`IccProfLib`) v2.0 or later.
  - JSON library for serialization/deserialization.
  - Standard C++ libraries.

### Input Requirements
- **Configurations:** Provided in JSON, IT8, or legacy text formats.

---

## Usage

### Common Commands
1. **Apply Color Transformations:**
   ```bash
   iccCmmConfig -apply <config_file.json>
   ```

2. **Generate Device Link Profile:**
   ```bash
   iccCmmConfig -link <link_file.json> <output_profile.icc>
   ```

3. **Export Configuration:**
   ```bash
   iccCmmConfig -export <config_file.json> <output_file.it8>
   ```

### Configuration File
A JSON configuration file can specify source and destination data, ICC profiles, and transformations. Example:
```json
{
  "srcFile": "source_data.it8",
  "dstFile": "output.icc",
  "srcEncoding": "unitFloat",
  "dstEncoding": "16Bit",
  "profiles": [
    {
      "iccFile": "profile1.icc",
      "intent": "perceptual",
      "transform": "colorimetric"
    },
    {
      "iccFile": "profile2.icc",
      "intent": "relative",
      "useBPC": true
    }
  ]
}
```

---

## Notes

### Data Encoding
- Supports multiple encodings (`8Bit`, `16Bit`, `float`, etc.).
- Allows seamless conversion between different formats.

### Rendering Intents
- Supports ICC-standard intents (`perceptual`, `relative`, `saturation`, `absolute`).
- Customizes workflows with options like Black Point Compensation (BPC).

### Profile Transformations
- Enables transformations like `colorimetric`, `spectral`, and `preview`.
- Supports high-precision interpolation and multi-process element (MPE) workflows.

---

## Compliance

This tool adheres to **ICC.2:2023** standards for color management module configuration.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
