
# ICC JSON Utility

## Overview
The ICC JSON Utility provides a set of functions for converting ICC-specific data structures to/from JSON format. It facilitates handling ICC data in JSON-based workflows and offers tools for parsing and serializing color profile configurations.

---

## Features
- **Serialization:**
  - Converts ICC data arrays and values to JSON format.
  - Supports specialized ICC types like `icFloatColorEncoding` and `icColorSpaceSignature`.
- **Deserialization:**
  - Parses JSON data back into ICC-specific data structures.
  - Supports arrays, lists, and primitive types.
- **File I/O:**
  - Reads JSON files into memory.
  - Writes ICC configurations to JSON files with customizable indentation.
- **String Handling:**
  - Provides utilities for escaping and formatting JSON strings.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - JSON library (`nlohmann/json`).
  - Standard C++ libraries.

---

## Usage

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

## Notes

### Templates
- Supports generic templates for converting arrays and values to JSON.
- Specialized templates handle ICC types like `icColorSpaceSignature` and `icFloatColorEncoding`.

### JSON Data Validation
- Provides type checking and validation when parsing JSON data.
- Handles unexpected types gracefully with error reporting.

### String Escaping
- Escapes special characters (`\`, `"`) for JSON compatibility.

### Integration with ICC Workflows
- Seamlessly integrates with other ICC tools, enabling JSON-based workflows for ICC profile management.

---

## Compliance

This tool adheres to **ICC.2:2023** standards for color management and JSON-based configuration.

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
