# IccFromXml

`IccFromXml` is a console application for parsing and converting XML-based ICC profiles into binary ICC profile files. This utility is built using the `IccProfLib` and `IccLibXML` libraries.

## Table of Contents

- [Overview](#overview)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Features](#features)
- [Build Instructions](#build-instructions)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

`IccFromXml` allows users to:
1. Parse XML ICC profiles.
2. Validate the XML against optional Relax NG schema files.
3. Convert the XML to binary ICC profiles with customizable options.

## Dependencies

Ensure the following dependencies are available before building or running the application:

- **IccProfLib**: ICC Profile manipulation library.
- **IccLibXML**: XML handling library for ICC Profiles.
- **Standard Libraries**:
  - `<stdio.h>` for input/output.
  - `<cstring>` for string manipulation.

## Usage

Run the executable with the following syntax:

```
IccFromXml xml_file saved_profile_file [-noid] [-v[=relax_ng_schema_file]]
```

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
