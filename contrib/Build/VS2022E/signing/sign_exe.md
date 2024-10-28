# PowerShell Script for Signing Multiple Executables with SignTool

This PowerShell script signs multiple `.exe` files using `signtool` with SHA256, applying a timestamp from Digicert. It uses the specified code signing settings and metadata to sign each file listed.

## Overview

- **Script Purpose**: Automates the signing of multiple executables with the `signtool` utility.
- **Digital Signing Algorithm**: SHA256 is used for both file digest and timestamp.
- **Metadata and Dlib**: The script leverages Azure Trusted Signing Client settings for signing each executable file.

## Script Details

### PowerShell Command:

```powershell
@("iccApplyNamedCmm.exe","iccApplyProfiles.exe","iccApplyToLink.exe","iccDumpProfile.exe","iccFromCube.exe","iccFromXml.exe","iccRoundTrip.exe","iccSpecSepToTiff.exe","iccTiffDump.exe","iccToXml.exe","iccV5DspObsToV4Dsp.exe","wxProfileDump.exe") | ForEach-Object { 
    & "signtool" sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\$_" 
}
