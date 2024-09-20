Get-ChildItem -Path "." -Recurse -Include *.exe, *.dll, *.a, *.lib | Select-Object FullName, LastWriteTime
