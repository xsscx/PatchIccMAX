Write-Host "Starting DemoIccMAX Static Branch Build......"
Write-Host "mkdir \Testing"
mkdir \testing
cd \testing
Write-Host "Clone vcpke"
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg.exe integrate install
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static
cd \testing
Write-Host "Clone PatchIccMAX"
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
Write-Host "checkout static"
git checkout static
Write-Host "Starting Build......"
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:CLToolAdditionalOptions="/MT /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /p:PreprocessorDefinitions="STATIC_LINK" /p:RuntimeLibrary=MultiThreaded /p:AdditionalLibraryDirectories="C:\testing\vcpkg\installed\x64-windows-static\lib" /p:AdditionalDependencies="wxmsw32u_core.lib%3Bwxbase32u.lib%3B%(AdditionalDependencies)" /p:LinkToolAdditionalOptions="/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" /t:Clean,Build /bl /verbosity:minimal > $null 2>&1; if ($LASTEXITCODE -eq 0) { Write-Host "Build succeeded." } else { Write-Host "Build failed with exit code $LASTEXITCODE." }
