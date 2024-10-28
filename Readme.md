
# Static Link Branch for Windows

Based on [Commit 1cbe656](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/5a433be3d048bb4c32e8e5a26dd07d0901cbe656)

Hello and Welcome to Hoyt's Static Link Branch for Windows of the DemoIccMAX Project.

```
mkdir \testing
cd \testing
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg.exe integrate install
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static
cd \testing
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git checkout static
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:CLToolAdditionalOptions="/MT /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /p:PreprocessorDefinitions="STATIC_LINK" /p:RuntimeLibrary=MultiThreaded /p:AdditionalLibraryDirectories="F:\test\vcpkg\installed\x64-windows-static\lib" /p:AdditionalDependencies="wxmsw32u_core.lib%3Bwxbase32u.lib%3B%(AdditionalDependencies)" /p:LinkToolAdditionalOptions="/DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" /t:Clean,Build
```
