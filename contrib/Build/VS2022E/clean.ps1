& "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" .\Build\MSVC\BuildAll_v22.sln /m /maxcpucount /t:Clean /p:Configuration=Debug /p:Platform=x64 /p:CLToolAdditionalOptions="/Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/DEBUG /INCREMENTAL:NO" /bl
& "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" .\Build\MSVC\BuildAll_v22.sln /m /maxcpucount /t:Clean /p:Configuration=Release /p:Platform=x64 /p:CLToolAdditionalOptions="/Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/DEBUG /INCREMENTAL:NO" /bl

# Poor Man's Clean
# Get-ChildItem -Path "Build/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Remove-Item -Force
# Get-ChildItem -Path "IccProfLib/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Remove-Item -Force
# Get-ChildItem -Path "IccXML" -Recurse -Include *.exe, *.dll, *.a, *.lib | Remove-Item -Force
# Get-ChildItem -Path "Testing/" -Recurse -Include *.exe | Remove-Item -Force
# Get-ChildItem -Path "Tools/" -Recurse -Include *.exe, *.dll, *.a, *.lib | Remove-Item -Force

# Clean,Build
# & "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" .\Build\MSVC\BuildAll_v22.sln /m /maxcpucount /t:Clean,Build /p:Configuration=Debug /p:Platform=x64 /p:CLToolAdditionalOptions="/Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/DEBUG /INCREMENTAL:NO" /bl
# & "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" .\Build\MSVC\BuildAll_v22.sln /m /maxcpucount /t:Clean,Build /p:Configuration=Release /p:Platform=x64 /p:CLToolAdditionalOptions="/Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/DEBUG /INCREMENTAL:NO" /bl
