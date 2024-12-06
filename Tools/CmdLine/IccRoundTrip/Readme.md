
# ICC Round Trip Tool

## Overview
This tool evaluates ICC profile round-trip accuracy and interoperability using Perceptual Reference Medium Gamut (PRMG) metrics. It computes DeltaE statistics to measure color differences between device color spaces and the profile connection space (PCS).

---

## Features
- Computes round-trip DeltaE statistics (Min, Mean, Max).
- Evaluates PRMG interoperability.
- Supports multiple rendering intents.
- Provides detailed Lab color metrics for analysis.

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
iccRoundTrip <profile_path> {rendering_intent=1 {use_mpe=0}}
```

### Parameters
1. **`<profile_path>`:** Path to the ICC profile to evaluate.
2. **`rendering_intent` (Optional):** Rendering intent:
   - `0`: Perceptual.
   - `1`: Relative (default).
   - `2`: Saturation.
   - `3`: Absolute.
3. **`use_mpe` (Optional):** Use Multi-Processing Elements (MPE):
   - `0`: Disabled (default).
   - `1`: Enabled.

### Examples
1. **Default Round Trip Evaluation:**
   ```bash
   iccRoundTrip profile.icc
   ```
2. **With Rendering Intent and MPE:**
   ```bash
   iccRoundTrip profile.icc 0 1
   ```

---

## Notes

### Round-Trip Evaluation
- Computes DeltaE between device Lab and PCS Lab (round-trip 1).
- Computes DeltaE between PCS Lab and device Lab (round-trip 2).
- Outputs Min, Mean, and Max DeltaE values.

### PRMG Interoperability
- Evaluates ICC profiles for compliance with PRMG.
- Outputs DeltaE statistics at thresholds (e.g., <=1.0, <=5.0).

### Metrics Output
- **Round Trip 1:** Device Lab → PCS Lab.
- **Round Trip 2:** PCS Lab → Device Lab.
- **PRMG Metrics:** Percentage of color differences below various DeltaE thresholds.

### Rendering Intents
- Supports all ICC-specified intents.

---

## Compliance

This tool adheres to **ICC.1:2022** and **ICC.2:2019** standards for profile evaluation.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
