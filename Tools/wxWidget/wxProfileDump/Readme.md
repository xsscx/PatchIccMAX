# wxProfileDump

`wxProfileDump` is a graphical application built using wxWidgets for inspecting and validating ICC profile contents. This utility provides a rich user interface to display profile metadata, validate compliance with ICC specifications, and analyze round-trip accuracy for profiles.

---

## Table of Contents

- [Overview](#overview)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Features](#features)
- [Build Instructions](#build-instructions)
- [Event Handlers](#event-handlers)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

`wxProfileDump` leverages wxWidgets to offer a GUI-based experience for interacting with ICC profiles, enabling:
- Inspection of profile header information and tags.
- Validation against ICC specifications.
- Visualization of round-trip and PRMG analysis for ICC profiles.

## Dependencies

- **wxWidgets**: For building the graphical interface.
- **IccProfLib**: For ICC profile manipulation.
- **Standard Libraries**:
  - `<wx/wx.h>` for GUI components.
  - `<IccProfile.h>`, `<IccTag.h>`, and others for ICC operations.

## Usage

### Launching the Application:

```
wxProfileDump [profile_file]
```
---

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
