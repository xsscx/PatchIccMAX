
# Demo ICC MAX CMM

## Overview
The Demo ICC MAX Color Management Module (CMM) demonstrates advanced color transformations and management for ICC profiles. It supports a variety of ICC workflows, including gamut checks, named colors, and multi-profile transformations.

---

## Features
- **Color Transformations:**
  - Handles a wide range of color spaces and color formats (e.g., RGB, CMYK, Lab, XYZ).
  - Supports gamut checks and transforms.
- **Profile Validation:**
  - Validates ICC profiles against compliance standards.
- **Named Colors:**
  - Converts named colors to indices and vice versa.
  - Supports named profile information extraction.
- **Multi-Profile Transformations:**
  - Creates transforms using multiple ICC profiles.
  - Handles rendering intents and interpolation types.
- **Device Link Profiles:**
  - Supports connections between input and output profiles using device links.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - ICC Profile Library (`IccProfLib`).
  - Standard C++ libraries.

---

## Usage

### Common Commands
1. **Create Transform:**
   - Multi-profile transformation:
     ```cpp
     CMCreateMultiProfileTransform(...);
     ```
2. **Color Validation:**
   - Check color validity and gamut:
     ```cpp
     CMCheckColors(...);
     CMCheckColorsInGamut(...);
     ```
3. **Named Colors:**
   - Convert named colors to indices:
     ```cpp
     CMConvertColorNameToIndex(...);
     ```
   - Convert indices to named colors:
     ```cpp
     CMConvertIndexToColorName(...);
     ```

### Example
Using the CMM to perform color transformations with RGB input and Lab output:
```cpp
CMTranslateColors(...);
```

---

## Notes

### Supported Color Spaces
- Grayscale, RGB, XYZ, Lab, CMYK, and high-fidelity (HiFi) colors.
- Validates input/output color types against ICC profiles.

### Transform Management
- Stores up to 1024 transforms simultaneously.
- Supports device, source, and destination profiles in transformations.

### Named Colors
- Handles named color profiles with prefix, suffix, and device coordinates.
- Supports up to the maximum number of entries defined in the ICC profile.

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
