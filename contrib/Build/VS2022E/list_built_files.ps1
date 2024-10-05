Get-ChildItem -Path "Build/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Select-Object FullName, LastWriteTime, CreationTime
Get-ChildItem -Path "IccProfLib/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Select-Object FullName, LastWriteTime, CreationTime
Get-ChildItem -Path "IccXML/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Select-Object FullName, LastWriteTime, CreationTime
Get-ChildItem -Path "Testing/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Select-Object FullName, LastWriteTime, CreationTime
Get-ChildItem -Path "Tools/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Select-Object FullName, LastWriteTime, CreationTime
