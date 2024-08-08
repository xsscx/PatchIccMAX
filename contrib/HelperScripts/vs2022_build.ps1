# Set up paths
$baseDir = "C:\tmp\build"
$repoDir = "$baseDir\PatchIccMAX"
$vcpkgDir = "$baseDir\vcpkg"
$patchDir = "$baseDir\patch"

# Create base directory
New-Item -ItemType Directory -Path $baseDir -Force

# Clone and setup vcpkg
cd $baseDir
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg.exe integrate install
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows

# Clone DemoIccMAX repository

git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6
git apply contrib/Research/vs2022-build-mods.patch

# Build the project
$msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
& $msbuildPath /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO"
