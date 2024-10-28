# Visual Studio 2022 Enterprise Build Instructions

## setup dirs

```
$baseDir = "C:\tmp\build"
$repoDir = "$baseDir\PatchIccMAX"
$vcpkgDir = "$baseDir\vcpkg"
$patchDir = "$baseDir\patch"
```
## Create base directory

```
New-Item -ItemType Directory -Path $baseDir -Force
```

## Clone and setup vcpkg

```
cd $baseDir
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg.exe integrate install
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static
```

## Clone DemoIccMAX repository

```
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git checkout development
```
## Build the project with Asan

```
cd PatchIccMAX
$msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
& $msbuildPath /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO"
```

### Build the project with a Build Log
```
cd PatchIccMAX
$msbuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"; & $msbuildPath /m:32 /maxcpucount:32 /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/Zi /Od /DDEBUG /W4 /FC" /p:LinkToolAdditionalOptions="/DEBUG /INCREMENTAL:NO" /p:BuildInParallel=true .\Build\MSVC\BuildAll_v22.sln /bl /verbosity:normal /t:Clean,Build
```
### Build the project with static link
```
cd PatchIccMAX
git checkout static
& $msbuildPath /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
```

## Expected Output

```
09:59:21:813	19>------ Build started: Project: All, Configuration: Debug x64 ------
09:59:21:934	19>"All Done!"
09:59:21:943	========== Build: 19 succeeded, 0 failed, 0 up-to-date, 0 skipped ==========
09:59:21:943	========== Build completed at 9:59 AM and took 28.105 seconds ==========
```
