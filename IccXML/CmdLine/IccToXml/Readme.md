
# ICC to XML Conversion Tool

## Overview
The ICC to XML Conversion Tool converts ICC profile data into XML format. It leverages the ICC Profile Library and XML utilities for accurate and efficient profile representation in XML.

---

## Features
- Converts ICC profiles into a structured XML format.
- Supports a wide range of ICC tags and multi-process elements (MPEs).
- Utilizes the ICC Profile Library and XML versioning for compatibility.

---

## Prerequisites

### Build Environment
- **Compiler:** Any C++17 compliant compiler (e.g., GCC, Clang, MSVC).
- **Dependencies:**
  - ICC Profile Library (`IccProfLib`).
  - XML Utility Libraries (`IccLibXML`).
  - Standard C++ libraries.

---

## Usage

### Command
```bash
IccToXml <src_icc_profile> <dest_xml_file>
```

### Parameters
1. **`<src_icc_profile>`:** Path to the input ICC profile file.
2. **`<dest_xml_file>`:** Path to save the generated XML file.

### Example
Convert an ICC profile to XML:
```bash
IccToXml input.icc output.xml
```

---

## Notes

### Libraries
- **ICC Profile Library (`IccProfLib`):** Handles ICC profile parsing and manipulation.
- **XML Libraries (`IccLibXML`):** Manages XML serialization and compatibility.

### Factory Implementation
- Registers `CIccTagXmlFactory` and `CIccMpeXmlFactory` for tag and MPE conversions.

### Memory Optimization
- Allocates memory dynamically to handle large profiles efficiently.

---

## Build Instructions

### Using CMake
1. Clone the DemoIccMAX repository and navigate to the tool directory:
   ```bash
   git clone https://github.com/YourRepo/DemoIccMAX.git
   cd DemoIccMAX/tools/IccToXml
   ```
2. Configure the build:
   ```bash
   cmake -B build -S .
   ```
3. Build the tool:
   ```bash
   cmake --build build
   ```

### Dependencies Setup
- Ensure `IccProfLib` and `IccLibXML` are built and available in your include/library paths:
  ```bash
  cmake -DCMAKE_PREFIX_PATH=/path/to/IccLibraries -B build -S .
  ```

---

## Compliance

This tool adheres to **ICC.2:2023** standards for profile representation and conversion.

---
## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
