## Delete Signed dll & lib

### 1. **DemoIccMAXCmm.dll**
   - Locations: 
     - `E:\repos\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Debug\`
     - `E:\repos\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Release\`
   - Deletes the DemoIccMAXCmm.dll library for the ICC MAX CMM (Color Management Module), including debug and release versions.

### 2. **DemoIccMAXCmm.lib**
   - Location: `E:\repos\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Release\`
   - Deletes the DemoIccMAXCmm.lib library for the ICC MAX CMM (Color Management Module), including debug and release versions.

## How to Clean the Project

The following PowerShell command can be used to clean the libraries by forcefully removing the relevant files:

```powershell
@("E:\repos\PatchIccMAX\Build\MSVC\x64\Debug_CRTDLL\IccLibXML_CRTDLL.lib", 
  "E:\repos\PatchIccMAX\Build\MSVC\x64\Release_CRTDLL\IccLibXML_CRTDLL.lib", 
  "E:\repos\PatchIccMAX\IccProfLib\x64\Release\IccProfLib.lib", 
  "E:\repos\PatchIccMAX\IccProfLib\x64\Release_CRTDLL\IccProfLib_CRTDLL.lib", 
  "E:\repos\PatchIccMAX\IccProfLib\x64\Release_DLL\IccProfLib_DLL.lib", 
  "E:\repos\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Release\IccFromXml.lib", 
  "E:\repos\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Release\IccToXml.lib", 
  "E:\repos\PatchIccMAX\IccXML\IccLibXML\x64\Release\IccLibXML.lib", 
  "E:\repos\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Debug\DemoIccMAXCmm.dll", 
  "E:\repos\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Release\DemoIccMAXCmm.dll", 
  "E:\repos\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Release\DemoIccMAXCmm.lib") | ForEach-Object { Remove-Item $_ -Force }
```
