
# ICC Profile Transformation Tool

## Overview
This tool converts **ICC version 5 display profiles** to **ICC version 4 display profiles**, incorporating **profile connection conditions (PCCs)** for spectral emission. The tool ensures compliance with ICC.2 standards, utilizing the International Color Consortium (ICC) libraries.

---

## Features
- Parses ICC v5 display profiles and PCCs.
- Validates profiles against version and structure constraints.
- Generates ICC v4 display profiles compatible with legacy systems.
- Incorporates metadata (e.g., profile descriptions and copyright).

---

## Usage

### Command
```bash
iccV5DspObsToV4Dsp <v5DspIccPath> <v5ObsPccPath> <v4DspIccPath>
```

### Parameters
1. `<v5DspIccPath>`: Path to the input ICC v5 display profile.
2. `<v5ObsPccPath>`: Path to the ICC v5 profile connection conditions.
3. `<v4DspIccPath>`: Path to save the generated ICC v4 profile.

### Example
```bash
iccV5DspObsToV4Dsp input_v5_display.icc input_v5_pcc.icc output_v4_display.icc
```

### Output
- **`output_v4_display.icc`:** An ICC v4 display profile compatible with the specified input conditions.

---

## Notes

### Profile Compatibility Checks
- Ensures the input profile is **ICC v5** with the required device class and version.
- Validates `AToB1Tag` structure for compatibility with spectral emission workflows.
- Requires PCCs with defined `customToStandardPccTag` and viewing conditions.

### Transformation Logic
1. **Curve Processing:**
   - Converts and interpolates curves using `curveSet` elements.
   - Generates gamma adjustment curves for the v4 profile.

2. **Matrix Transformation:**
   - Applies spectral emission `emissionMatrix` and PCC corrections.
   - Computes XYZ primary colorants for the v4 profile.

3. **Metadata Preservation:**
   - Transfers profile descriptions and copyrights to the output profile.

---


## Compliance

This tool adheres to the **ICC.2:2023** and **ICC.2:2019** standards for profile creation and transformation. See the ICC specifications for more details:
- [ICC.2:2023 Specifications](https://www.color.org)
- [ICC.2:2019 Errata List](https://www.color.org/errata)

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
