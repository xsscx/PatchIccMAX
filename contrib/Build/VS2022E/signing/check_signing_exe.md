
# PowerShell Signature Verification Script

This PowerShell script verifies `.exe` files for digital signatures, specifically checking if they are signed by "David H Hoyt LLC". It logs the results and provides a summary of the number of signed files.

## Overview

- **Logs actions and errors** to both the console and a log file.
- Uses `signtool` from the system `PATH` to verify the signature of each `.exe` file in a specified directory.
- Provides a final summary of the number of files signed by "David H Hoyt LLC".

## Script Functionality

1. **Log Setup**: 
   - A log file is created in the `E:
epos\PatchIccMAX\Testing` directory, with the current timestamp in the file name.
   - All actions are logged to both the console and the log file.

2. **Signature Verification**:
   - The script recursively searches for `.exe` files in the `E:
epos\PatchIccMAX\Testing` directory.
   - It verifies each file using `signtool`.
   - If a file is signed by "David H Hoyt LLC", it increments the count and logs the result.

3. **Error Handling**:
   - If an error occurs during verification (e.g., missing file, signtool error), the script logs the error message but continues processing the remaining files.

4. **Summary**:
   - At the end of the script, it provides a summary of the number of files signed by "David H Hoyt LLC".

## How to Use

1. **Ensure `signtool` is in your system `PATH`**.
2. Place this script in your PowerShell environment.
3. Run the script in PowerShell:
   ```powershell
   .\check_signing_exe.ps1
   ```

4. The script will log its progress to both the console and a log file.

## Example Log Output

```
-----------------------------
Verification Process Start: 10/26/2024 19:20:13
-----------------------------
Checking file: E:
epos\PatchIccMAX\Testing\example1.exe
SIGNED: E:
epos\PatchIccMAX\Testing\example1.exe
Checking file: E:
epos\PatchIccMAX\Testing\example2.exe
NOT SIGNED or SIGNED by another entity: E:
epos\PatchIccMAX\Testing\example2.exe
-----------------------------
Process Complete: 10/26/2024 19:25:13
Number of files signed by David H Hoyt LLC: 12
-----------------------------
```

## Requirements

- PowerShell
- `signtool` installed and in the system `PATH`.

## License

This script is provided as-is, without any warranties. Use it at your own risk.
