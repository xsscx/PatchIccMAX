
# Reference ICC MAX CMM

## Overview
The Reference ICC MAX Color Management Module (CMM) is a sample implementation of advanced color management workflows. It demonstrates the core functionalities of color matching, gamut checking, and profile concatenation while adhering to ICC standards.

---

## Features
- **Color Matching:**
  - Converts between color spaces (RGB, CMYK, Lab, XYZ, Gray).
  - Supports multiple transformations and rendering intents.
- **Profile Concatenation:**
  - Concatenates profiles to create complex workflows.
  - Handles profile transformations through Device-to-PCS and PCS-to-Device operations.
- **Gamut Checking:**
  - Validates whether colors are within the gamut of a given profile.
- **Bitmap Support:**
  - Processes images in a variety of color spaces (Gray, RGB, CMYK, XYZ, Lab).
  - Supports both 8-bit and 16-bit per channel depths.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - ICC Profile Library (`IccProfLib`).
  - ApplicationServices framework for macOS.

---

## Usage

### Functionality
1. **Color Matching:**
   - Matches individual colors or bitmaps between source and destination profiles:
     ```cpp
     CMMMatchColors(...);
     CMMMatchBitmap(...);
     ```
2. **Gamut Checking:**
   - Validates gamut for colors and bitmaps:
     ```cpp
     CMMCheckColors(...);
     CMMCheckBitmap(...);
     ```
3. **Profile Concatenation:**
   - Creates multi-profile workflows:
     ```cpp
     NCMMConcatInit(...);
     ```

### Example
Using the CMM to translate an image from RGB to Lab:
```cpp
CMMMatchBitmap(&cmmRefcon, &srcBitmap, nullptr, nullptr, &dstBitmap);
```

---

## Notes

### Color Conversions
- Converts between various color spaces:
  - RGB, CMYK, XYZ, Lab, Gray.
- Supports complex transformations like:
  - RGB → Lab → CMYK.

### Memory Management
- Uses dynamic memory allocation for flexibility in large workflows.

### Platform-Specific Implementation
- Relies on macOS ApplicationServices for ColorSync integration.

---

## Compliance

This tool adheres to **ICC.2:2023** standards for color management module operations.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
