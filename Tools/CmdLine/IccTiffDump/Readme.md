
# ICC TIFF Metadata Dump Tool

## Overview
This tool extracts metadata from TIFF images and dumps detailed information, including any embedded ICC profiles. It also allows exporting ICC profiles from TIFF files for further analysis or usage.

---

## Features
- Opens TIFF files and retrieves metadata (dimensions, resolution, compression, etc.).
- Extracts and displays embedded ICC profile information.
- Supports spectral and bi-spectral PCS details if present in the ICC profile.

---

## Usage

### Command
```bash
iccTiffDump <tiff_file> [exported_icc_file]
```

### Parameters
1. `<tiff_file>`: Path to the input TIFF image.
2. `[exported_icc_file]`: Optional. Path to save the embedded ICC profile.

### Example
```bash
iccTiffDump sample.tiff exported_profile.icc
```

### Output
- Displays metadata for the specified TIFF file.
- Extracts embedded ICC profile details, including:
  - Color Space and PCS (Colorimetric/Spectral).
  - Description from `ProfileDescriptionTag`.

---

## Notes

### Metadata Extraction
- Fetches details like dimensions, resolution, and compression settings.
- Reads and identifies planar configurations and photometric interpretations.

### ICC Profile Handling
1. **Embedded Profile Detection:**
   - Verifies if an ICC profile is embedded and retrieves it.
2. **Detailed Information:**
   - Extracts color space, spectral range, and bi-spectral range details.
   - Reads profile descriptions (text or multi-localized Unicode).

---

## Compliance

This tool adheres to the **ICC.2:2023** and **TIFF/EP** standards for image and profile analysis.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
