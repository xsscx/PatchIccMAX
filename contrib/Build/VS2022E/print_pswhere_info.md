# PowerShell Script for Locating Visual Studio with vswhere.exe

This PowerShell script uses `vswhere.exe` to locate installations of Visual Studio and converts the output into JSON format for further processing. The `vswhere.exe` utility is provided by Microsoft to help find installed Visual Studio instances.

## Overview

- **Finds Visual Studio Installations**: Uses `vswhere.exe` to locate all installed Visual Studio instances.
- **Formats the Output as JSON**: The output of `vswhere.exe` is converted to JSON format for easier parsing in PowerShell.
- **Used for Automation**: You can use this information to automate tasks such as selecting the correct Visual Studio installation for builds or other automated workflows.

## Script Details

### PowerShell Command:

```powershell
&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -format json | ConvertFrom-Json
