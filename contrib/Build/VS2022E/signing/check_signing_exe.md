
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
Verifying: E:\repos\PatchIccMAX\Testing\iccToXml.exe

Signature Index: 0 (Primary Signature)
Hash of file (sha256): 2CCC929A6877D23C67536AE03126389CCA43A416C53A0D58B214A0F946F831D4

Signing Certificate Chain:
    Issued to: Microsoft Identity Verification Root Certificate Authority 2020
    Issued by: Microsoft Identity Verification Root Certificate Authority 2020
    Expires:   Sun Apr 16 14:44:40 2045
    SHA1 hash: F40042E2E5F7E8EF8189FED15519AECE42C3BFA2

        Issued to: Microsoft ID Verified Code Signing PCA 2021
        Issued by: Microsoft Identity Verification Root Certificate Authority 2020
        Expires:   Tue Apr 01 16:15:20 2036
        SHA1 hash: 8E750F459DAF9A79D6370DB747AD2226866AD818

            Issued to: Microsoft ID Verified CS AOC CA 01
            Issued by: Microsoft ID Verified Code Signing PCA 2021
            Expires:   Mon Apr 13 13:31:54 2026
            SHA1 hash: D7B1118AFBB879D9F2F8E98B9AC12F9367FACE88

                Issued to: David H Hoyt LLC
                Issued by: Microsoft ID Verified CS AOC CA 01
                Expires:   Tue Oct 29 09:08:18 2024
                SHA1 hash: E20F0D74A2481A62E715034709F968F3BD01C736

The signature is timestamped: Sat Oct 26 17:58:21 2024
Timestamp Verified by:
    Issued to: DigiCert Assured ID Root CA
    Issued by: DigiCert Assured ID Root CA
    Expires:   Sun Nov 09 20:00:00 2031
    SHA1 hash: 0563B8630D62D75ABBC8AB1E4BDFB5A899B24D43

        Issued to: DigiCert Trusted Root G4
        Issued by: DigiCert Assured ID Root CA
        Expires:   Sun Nov 09 19:59:59 2031
        SHA1 hash: A99D5B79E9F1CDA59CDAB6373169D5353F5874C6

            Issued to: DigiCert Trusted G4 RSA4096 SHA256 TimeStamping CA
            Issued by: DigiCert Trusted Root G4
            Expires:   Sun Mar 22 19:59:59 2037
            SHA1 hash: B6C8AF834D4E53B673C76872AA8C950C7C54DF5F

                Issued to: DigiCert Timestamp 2024
                Issued by: DigiCert Trusted G4 RSA4096 SHA256 TimeStamping CA
                Expires:   Sun Nov 25 19:59:59 2035
                SHA1 hash: DBD385EE62DBD23E7BE4F67148508724D5865B45


Successfully verified: E:\repos\PatchIccMAX\Testing\iccToXml.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0
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
