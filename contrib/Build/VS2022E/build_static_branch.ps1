# Specif cot the PatchIccMAX Static Branch in the Visual Studio Site
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:CLToolAdditionalOptions="/MT /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /p:PreprocessorDefinitions="STATIC_LINK" /p:RuntimeLibrary=MultiThreaded /p:AdditionalLibraryDirectories="F:\test\vcpkg\installed\x64-windows-static\lib" /p:AdditionalDependencies="wxmsw32u_core.lib%3Bwxbase32u.lib%3B%(AdditionalDependencies)" /t:Clean,Build
 
