# PowerShell Script for Building with MSBuild

This script compiles a solution using **MSBuild** with specific build parameters and dependencies. The `msbuild` command is customized for an x64 release configuration, using **Vcpkg** for additional libraries.

## Overview

- **Builds a Solution (`.sln`) File**: The script builds the `BuildAll_v22.sln` solution using `msbuild`.
- **Static Linking**: Specifies static linking with `/MT` and other options for performance optimization.
- **Vcpkg Integration**: Uses **Vcpkg** to manage and integrate third-party libraries.

## Script Details

This is specific to building a static .exe which is now configured in the Static Brnach of the Visual Studio Train of the PatchIccMAX Project by David H Hoyt LLC

### PowerShell Command:

```powershell
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln `
/p:Configuration=Release `
/p:Platform=x64 `
/p:VcpkgTriplet=x64-windows-static `
/p:CLToolAdditionalOptions="/MT /W4" `
/p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" `
/p:PreprocessorDefinitions="STATIC_LINK" `
/p:RuntimeLibrary=MultiThreaded `
/p:AdditionalLibraryDirectories="F:\test\vcpkg\installed\x64-windows-static\lib" `
/p:AdditionalDependencies="wxmsw32u_core.lib%3Bwxbase32u.lib%3B%(AdditionalDependencies)" `
/t:Clean,Build
