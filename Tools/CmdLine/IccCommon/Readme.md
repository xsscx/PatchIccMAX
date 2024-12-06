
# ICC Common Tools

This document consolidates the descriptions and usage instructions for the ICC JSON Utility and ICC CMM Configuration Tool.

---

## 1. ICC JSON Utility

### Overview
The ICC JSON Utility provides a set of functions for converting ICC-specific data structures to/from JSON format. It facilitates handling ICC data in JSON-based workflows and offers tools for parsing and serializing color profile configurations.

### Features
- **Serialization:** Converts ICC data arrays and values to JSON format.
- **Deserialization:** Parses JSON data back into ICC-specific data structures.
- **File I/O:** Reads and writes JSON files with customizable indentation.
- **String Handling:** Escapes and formats JSON strings for compatibility.

### Prerequisites
- **Compiler:** C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:** JSON library (`nlohmann/json`) and standard C++ libraries.

### Example Code
1. **Converting ICC Array to JSON:**
   ```cpp
   icUInt8Number myArray[] = {1, 2, 3};
   std::string jsonStr = arrayToJson(myArray, 3);
   ```

2. **Parsing JSON File:**
   ```cpp
   json j;
   if (loadJsonFrom(j, "config.json")) {
       std::cout << "Successfully loaded JSON file!" << std::endl;
   }
   ```

3. **Saving JSON Data:**
   ```cpp
   json j;
   j["colorSpace"] = "RGB";
   saveJsonAs(j, "output.json", 4);
   ```

---

## 2. ICC CMM Configuration Tool

### Overview
The ICC CMM Configuration Tool provides utilities for managing Color Management Modules (CMM). It allows advanced control of color profiles, transformations, and workflow customization using JSON-based settings.

### Features
- **Profile Management:** Parses and applies ICC profiles with environment variables.
- **Workflow Customization:** Configures source/destination encodings, precision, and interpolation.
- **Export and Import:** Converts configurations to/from JSON, IT8, and legacy text formats.
- **Debugging:** Includes debug calculation modes and logging.

### Prerequisites
- **Compiler:** C++17 compliant compiler.
- **Dependencies:** ICC Profile Library (`IccProfLib`), JSON library for serialization/deserialization.

### Usage
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

### Configuration File Example
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

## Compliance

These tools adhere to **ICC.2:2023** standards for color management and JSON-based configurations.

---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
