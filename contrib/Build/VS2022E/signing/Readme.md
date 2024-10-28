# Trusted Signing

This directory contains helper scripts for managing the Trusted signing CI/CD.

## Example

```
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccApplyNamedCmm.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccApplyProfiles.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccApplyToLink.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccDumpProfile.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccFromCube.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccFromXml.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccRoundTrip.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccSpecSepToTiff.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccTiffDump.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccToXml.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\iccV5DspObsToV4Dsp.exe"
signtool sign /v /debug /fd SHA256 /tr "http://timestamp.digicert.com" /td SHA256 /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\wxProfileDump.exe"
```
