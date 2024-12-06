
# ICC Apply Named CMM Tool

## Overview
This tool applies a sequence of ICC profiles to color data (text or structured) using a named Color Management Module (CMM). It supports advanced features like JSON-based configuration and debugging of profile applications. This tool is particularly useful for transforming color data using iccMAX workflows.

---

## Features
- Processes color data through a sequence of ICC profiles.
- Supports JSON configuration files for streamlined batch processing.
- Provides advanced debugging via the **LogDebugger** interface.
- Handles a variety of input/output formats, including IT8, legacy, and JSON.
- Supports spectral workflows with Profile Connection Conditions (PCCs).

---

## Usage

### Command
```bash
iccApplyNamedCmm [-cfg <config_file_path>] [options]
```

### Options
1. **Configuration Mode:**
   - `-cfg <config_file_path>`: JSON file specifying input data and profile sequence.

2. **Argument-Based Mode:**
   ```bash
   iccApplyNamedCmm [-debugcalc] <data_file_path> <final_data_encoding>:FmtPrecision:FmtDigits <interpolation> {{-ENV:Name value} <profile_file_path> <Rendering_intent> {-PCC <connection_conditions_path>}}
   ```

   **Key Arguments:**
   - `<final_data_encoding>`:
     - `0`: `icEncodeValue`
     - `1`: `icEncodePercent`
     - `2`: `icEncodeUnitFloat`
     - `3`: `icEncodeFloat`
     - `4`: `icEncode8Bit`
     - `5`: `icEncode16Bit`
     - `6`: `icEncode16BitV2`
   - `<interpolation>`:
     - `0`: Linear
     - `1`: Tetrahedral
   - `<Rendering_intent>`:
     - `0`: Perceptual
     - `1`: Relative
     - `2`: Saturation
     - `3`: Absolute

### Examples
1. **Using a JSON configuration file:**
   ```bash
   iccApplyNamedCmm -cfg config.json
   ```

2. **Direct arguments:**
   ```bash
   iccApplyNamedCmm data.txt 0:4:5 1 -ENV:Debug true profile.icc 0 -PCC pcc.icc
   ```

---

## Notes

### JSON Configuration
- Define all processing parameters in a structured JSON format.
- Includes data sources, profile sequences, and options for debugging and precision.

### Debugging
- Enable detailed logs using the `-debugcalc` option.
- Logs include stack operations and applied calculations.

### Supported Formats
- **Input:** JSON, IT8, legacy text files.
- **Output:** JSON, IT8.

### Advanced Features
- **PCC Handling:** Incorporates Profile Connection Conditions for spectral workflows.
- **Sub-Profiles:** Supports iccMAX v5 sub-profiles.
- **Environment Variables:** Allows dynamic CMM configuration using environment hints.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
