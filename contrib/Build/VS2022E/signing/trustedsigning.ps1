Connect-AzAccount
& "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe"  sign /v /fd SHA256 /td SHA256 /tr "http://timestamp.digicert.com" /dlib "E:\repos\Microsoft.Trusted.Signing.Client\bin\x64\Azure.CodeSigning.Dlib.dll" /dmdf "C:\AzureTrustedSigning\metadata.json" "E:\repos\PatchIccMAX\Testing\*.exe"
