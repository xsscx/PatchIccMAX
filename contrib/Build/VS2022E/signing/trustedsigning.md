# Signing Executables with Azure Code Signing and Signtool

How to authenticate with Azure using `Connect-AzAccount` and sign your executables using the `signtool.exe` from the Windows SDK. The signing process uses Azure's Trusted Signing service.

## Prerequisites

- **Azure PowerShell** installed on your system.
- **Windows SDK** installed, including `signtool.exe` (at least version 10.0.22621.0).
- An **Azure Code Signing** setup for your project.
- Necessary metadata and libraries (e.g., `metadata.json` and `Azure.CodeSigning.Dlib.dll`).

## Step 1: Authenticate with Azure

Before you can sign your files, you need to authenticate your session with Azure using the `Connect-AzAccount` command.

### Connect to Azure:

Run the following PowerShell command to authenticate with Azure and run signtool:

```powershell
Connect-AzAccount
 & "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe"  sign /v /fd SHA256 /td SHA256 /tr "http://timestamp.digicert.com" /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\*.exe"
```
