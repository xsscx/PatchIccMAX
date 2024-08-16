Hello -

This PR Preview modifies the VS2022 Configs after installing the deps with vcpgk and builds the project with reduced friction. 

Any feedback appreciated.

### Powershell 7
Paste the Powershell code into the Terminal to Build with Visual Studio 2022
```
# Create a temporary directory for the build process
$tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $tempDir -Force

# Set up paths within the temp directory
$baseDir = "$tempDir\DemoIccMAXBuild"
$vcpkgDir = "$baseDir\vcpkg"
$patchDir = "$baseDir\patch"
$outputDir = "$baseDir\output"

# Create necessary directories
New-Item -ItemType Directory -Path $baseDir -Force
New-Item -ItemType Directory -Path $outputDir -Force

# Clone and setup vcpkg
if (-not (Test-Path "$vcpkgDir")) {
    git clone https://github.com/microsoft/vcpkg.git $vcpkgDir
}
cd $vcpkgDir
if (-not (Test-Path ".\vcpkg.exe")) {
    .\bootstrap-vcpkg.bat
}
.\vcpkg.exe integrate install
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows

# Clone DemoIccMAX repository and apply patch
cd $baseDir
if (-not (Test-Path "$baseDir\PatchIccMAX")) {
    git clone https://github.com/xsscx/PatchIccMAX.git
}
cd "$baseDir\PatchIccMAX"
git checkout development

# Verify and display the directory contents
$solutionPath = "$baseDir\PatchIccMAX\Build\MSVC\BuildAll_v22.sln"
if (!(Test-Path $solutionPath)) {
    Write-Error "Solution file does not exist: $solutionPath"
    Get-ChildItem -Path "$baseDir\PatchIccMAX\Build\MSVC"
    exit 1
} else {
    Write-Host "Solution file exists at: $solutionPath"
}

# Build the project
$msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
$buildDir = "$baseDir\PatchIccMAX"
cd $buildDir
& $msbuildPath /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO"


# Optionally clean up the temporary directory after the build
# Remove-Item -Recurse -Force $tempDir
```
### git diff 
```
Repository 1: https://github.com/InternationalColorConsortium/DemoIccMAX.git (Branch: development)
Repository 2: https://github.com/xsscx/PatchIccMAX.git (Branch: development)

 .../.github/ISSUE_TEMPLATE/bug_report.md"          |   38 +
 .../.github/ISSUE_TEMPLATE/custom.md"              |   10 +
 .../.github/ISSUE_TEMPLATE/feature_request.md"     |   20 +
 .../Build/Cmake/CMakeLists.txt"                    |    6 +-
 .../Build/MSVC/BuildAll_v16.sln"                   |   45 -
 .../Build/MSVC/BuildAll_v22.sln"                   |  100 ++
 .../Build/MSVC/BuildAll_v22.vcxproj"               |    8 +-
 .../Build/MSVC/BuildDefs.props"                    |    4 +-
 .../Build/MSVC/BuildDefs_v16.props"                |    6 +-
 .../ChangeLog"                                     |    7 -
 .../DemoIccMAX-Readme.html"                        |   29 +-
 .../IccProfLib/IccCmm.cpp"                         |   86 +-
 .../IccProfLib/IccCmm.h"                           |   31 -
 .../IccProfLib/IccEnvVar.cpp"                      |   10 -
 .../IccProfLib/IccEnvVar.h"                        |   12 -
 .../IccProfLib/IccMpeBasic.cpp"                    |   60 +-
 .../IccProfLib/IccMpeBasic.h"                      |   28 -
 .../IccProfLib/IccMpeSpectral.cpp"                 |   60 +-
 .../IccProfLib/IccMpeSpectral.h"                   |   25 -
 .../IccProfLib/IccProfLibVer.h"                    |    2 +-
 .../IccProfLib/IccProfile.cpp"                     |   20 +-
 .../IccProfLib/IccTagBasic.cpp"                    |    4 +-
 .../IccProfLib/IccTagFactory.cpp"                  |    2 -
 .../IccProfLib/IccTagLut.cpp"                      |  133 +-
 .../IccProfLib/IccTagLut.h"                        |   33 +-
 .../IccProfLib/icProfileHeader.h"                  |    1 -
 .../IccXML/IccLibXML/IccLibXMLVer.h"               |    2 +-
 .../IccXML/IccLibXML/IccLibXML_CRTDLL_v22.vcxproj" |    8 +-
 .../IccXML/IccLibXML/IccLibXML_v22.sln"            |   31 +
 .../IccXML/IccLibXML/IccLibXML_v22.vcxproj"        |    9 +-
 .../Readme.md"                                     |   37 +-
 .../Testing/CreateAllProfiles_d.bat"               |  160 ++
 .../Testing/HDR/BT2100HlgFullDisplay.xml"          |  124 +-
 .../Testing/RunTests_d.bat"                        |  102 ++
 .../CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp" |  664 ++++---
 .../IccApplyNamedCmm/iccApplyNamedCmm_v16.vcxproj" |   14 +-
 .../iccApplyNamedCmm_v16.vcxproj.filters"          |   14 -
 .../CmdLine/IccApplyProfiles/iccApplyProfiles.cpp" |  281 ++-
 .../IccApplyProfiles/iccApplyProfiles_v22.vcxproj" |   26 +-
 .../IccApplyToLink/iccApplyToLink_v16.vcxproj"     |    8 +-
 .../IccCommon/IccCmmConfig.cpp" => /dev/null       | 1825 --------------------
 .../CmdLine/IccCommon/IccCmmConfig.h" => /dev/null |  191 --
 .../IccCommon/IccJsonUtil.cpp" => /dev/null        |  427 -----
 .../CmdLine/IccCommon/IccJsonUtil.h" => /dev/null  |   64 -
 .../CmdLine/IccFromCube/iccFromCube_v16.vcxproj"   |    8 +-
 .../IccSpecSepToTiff/iccSpecSepToTiff_v22.vcxproj" |   24 +-
 .../CmdLine/IccTiffDump/iccTiffDump_v22.vcxproj"   |   38 +-
 .../IccV5DspObsToV4Dsp_v22.vcxproj"                |    2 +-
 .../wxWidget/wxProfileDump/wxProfileDump.cpp"      |    4 +-
 .../wxWidget/wxProfileDump/wxProfileDump_v22.sln"  |   55 +
 .../wxProfileDump/wxProfileDump_v22.vcxproj"       |    6 +-
 .../workflows/macos-self-hosted-example.yml"       |   43 +
 .../workflows/windows-vs2022-vcpkg-example.yml"    |  102 ++
 .../contrib/HelperScripts/vs2022_build.ps1"        |   27 +
 69 files changed, 1380 insertions(+), 3733 deletions(-)
```

## Build Results
```
Get-ChildItem -Path Testing -Recurse -Include *.dll, *.lib, *.exe  | Sort-Object | ForEach-Object { Write-Host $_ }
```
```
C:\opt\test\16\PatchIccMAX\Testing\DemoIccMAXCmm.dll
C:\opt\test\16\PatchIccMAX\Testing\DemoIccMAXCmm.lib
C:\opt\test\16\PatchIccMAX\Testing\iccApplyNamedCmm.exe
C:\opt\test\16\PatchIccMAX\Testing\iccApplyNamedCmm_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iccApplyProfiles.exe
C:\opt\test\16\PatchIccMAX\Testing\iccApplyProfiles_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iccApplyToLink.exe
C:\opt\test\16\PatchIccMAX\Testing\iccApplyToLink_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iccDumpProfile.exe
C:\opt\test\16\PatchIccMAX\Testing\iccDumpProfile_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iccFromCube.exe
C:\opt\test\16\PatchIccMAX\Testing\iccFromCube_d.exe
C:\opt\test\16\PatchIccMAX\Testing\IccFromXml.exe
C:\opt\test\16\PatchIccMAX\Testing\iccFromXml_d.exe
C:\opt\test\16\PatchIccMAX\Testing\IccLibXml.lib
C:\opt\test\16\PatchIccMAX\Testing\IccLibXML_CRTDLL.lib
C:\opt\test\16\PatchIccMAX\Testing\IccProfLib.lib
C:\opt\test\16\PatchIccMAX\Testing\IccProfLib_CRTDLL.lib
C:\opt\test\16\PatchIccMAX\Testing\IccProfLib_DLL.dll
C:\opt\test\16\PatchIccMAX\Testing\IccProfLib_DLL.lib
C:\opt\test\16\PatchIccMAX\Testing\iccRoundTrip.exe
C:\opt\test\16\PatchIccMAX\Testing\iccRoundTrip_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iccSpecSepToTiff.exe
C:\opt\test\16\PatchIccMAX\Testing\iccSpecSepToTiff_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iccTiffDump.exe
C:\opt\test\16\PatchIccMAX\Testing\iccTiffDump_d.exe
C:\opt\test\16\PatchIccMAX\Testing\IccToXml.exe
C:\opt\test\16\PatchIccMAX\Testing\iccToXml_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iccV5DspObsToV4Dsp.exe
C:\opt\test\16\PatchIccMAX\Testing\iccV5DspObsToV4Dsp_d.exe
C:\opt\test\16\PatchIccMAX\Testing\iconv-2.dll
C:\opt\test\16\PatchIccMAX\Testing\jpeg62.dll
C:\opt\test\16\PatchIccMAX\Testing\liblzma.dll
C:\opt\test\16\PatchIccMAX\Testing\libpng16.dll
C:\opt\test\16\PatchIccMAX\Testing\libxml2.dll
C:\opt\test\16\PatchIccMAX\Testing\pcre2-16.dll
C:\opt\test\16\PatchIccMAX\Testing\tiff.dll
C:\opt\test\16\PatchIccMAX\Testing\wxbase32u_vc_custom.dll
C:\opt\test\16\PatchIccMAX\Testing\wxmsw32u_core_vc_custom.dll
C:\opt\test\16\PatchIccMAX\Testing\wxProfileDump.exe
C:\opt\test\16\PatchIccMAX\Testing\wxProfileDump_d.exe
C:\opt\test\16\PatchIccMAX\Testing\zlib1.dll
```

## Fixups | TODO
- The Build Config needs to properly copy the unique .DLL and .lib files to Testing so there is a 100% Pass Rate for the Unit Tests to check if the Program has output.

### Copy Libs to Testing/
```
# Define the root directory to scan
$rootDir = "C:\tmp\test\builds\vcpkg\PatchIccMAX"

# Define the destination directory
$destinationDir = Join-Path -Path $rootDir -ChildPath "Testing"

# Scan for .dll and .lib files in the root directory and subdirectories
$sourceFiles = Get-ChildItem -Path $rootDir -Recurse -Include *.dll, *.lib

# Remove duplicates based on file name
$uniqueFiles = $sourceFiles | Sort-Object -Property Name -Unique

# Create a list to store unique file names
$uniqueFileNames = @()

# Copy only unique files to the Testing directory
foreach ($file in $uniqueFiles) {
    $destinationPath = Join-Path -Path $destinationDir -ChildPath $file.Name

    # Add unique file names to the list
    if (-not $uniqueFileNames.Contains($file.Name)) {
        $uniqueFileNames += $file.Name

        # Copy the unique file to the destination directory
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Copied $($file.FullName) to $destinationPath"
    }
}

# Output the list of unique file names
Write-Host "Unique .lib and .dll file names:"
$uniqueFileNames | Sort-Object | ForEach-Object { Write-Host $_ }

```

### Unique Libs
```
Unique .lib and .dll file names:
7za.dll
7-ZipFar.dll
7-ZipFar64.dll
7zxa.dll
charset.lib
charset-1.dll
DemoIccMAXCmm.dll
DemoIccMAXCmm.lib
GlU32.Lib
IccLibXml.lib
IccLibXML_CRTDLL.lib
IccProfLib.lib
IccProfLib_CRTDLL.lib
IccProfLib_DLL.dll
IccProfLib_DLL.lib
iconv.lib
iconv-2.dll
jpeg.lib
jpeg62.dll
libexpat.dll
libexpat.lib
libexpatd.dll
libexpatd.lib
liblzma.dll
libpng16.dll
libpng16.lib
libpng16d.dll
libpng16d.lib
libxml2.dll
libxml2.lib
lzma.lib
nanosvg.lib
nanosvgrast.lib
OpenGL32.Lib
pcre2-16.dll
pcre2-16.lib
pcre2-16d.dll
pcre2-16d.lib
pcre2-32.dll
pcre2-32.lib
pcre2-32d.dll
pcre2-32d.lib
pcre2-8.dll
pcre2-8.lib
pcre2-8d.dll
pcre2-8d.lib
pcre2-posix.dll
pcre2-posix.lib
pcre2-posixd.dll
pcre2-posixd.lib
tiff.dll
tiff.lib
tiffd.dll
tiffd.lib
turbojpeg.dll
turbojpeg.lib
wxbase32u.lib
wxbase32u_net.lib
wxbase32u_net_vc_custom.dll
wxbase32u_vc_custom.dll
wxbase32u_xml.lib
wxbase32u_xml_vc_custom.dll
wxbase32ud.lib
wxbase32ud_net.lib
wxbase32ud_net_vc_custom.dll
wxbase32ud_vc_custom.dll
wxbase32ud_xml.lib
wxbase32ud_xml_vc_custom.dll
wxmsw32u_adv.lib
wxmsw32u_adv_vc_custom.dll
wxmsw32u_aui.lib
wxmsw32u_aui_vc_custom.dll
wxmsw32u_core.lib
wxmsw32u_core_vc_custom.dll
wxmsw32u_gl.lib
wxmsw32u_gl_vc_custom.dll
wxmsw32u_html.lib
wxmsw32u_html_vc_custom.dll
wxmsw32u_propgrid.lib
wxmsw32u_propgrid_vc_custom.dll
wxmsw32u_qa.lib
wxmsw32u_qa_vc_custom.dll
wxmsw32u_ribbon.lib
wxmsw32u_ribbon_vc_custom.dll
wxmsw32u_richtext.lib
wxmsw32u_richtext_vc_custom.dll
wxmsw32u_stc.lib
wxmsw32u_stc_vc_custom.dll
wxmsw32u_xrc.lib
wxmsw32u_xrc_vc_custom.dll
wxmsw32ud_adv.lib
wxmsw32ud_adv_vc_custom.dll
wxmsw32ud_aui.lib
wxmsw32ud_aui_vc_custom.dll
wxmsw32ud_core.lib
wxmsw32ud_core_vc_custom.dll
wxmsw32ud_gl.lib
wxmsw32ud_gl_vc_custom.dll
wxmsw32ud_html.lib
wxmsw32ud_html_vc_custom.dll
wxmsw32ud_propgrid.lib
wxmsw32ud_propgrid_vc_custom.dll
wxmsw32ud_qa.lib
wxmsw32ud_qa_vc_custom.dll
wxmsw32ud_ribbon.lib
wxmsw32ud_ribbon_vc_custom.dll
wxmsw32ud_richtext.lib
wxmsw32ud_richtext_vc_custom.dll
wxmsw32ud_stc.lib
wxmsw32ud_stc_vc_custom.dll
wxmsw32ud_xrc.lib
wxmsw32ud_xrc_vc_custom.dll
zlib.lib
zlib1.dll
zlibd.lib
zlibd1.dll
```

### Test Outputs
```
# Define the list of .exe files
$exeFiles = @(
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Debug\IccFromXml.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Debug\IccToXml.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccApplyNamedCmm_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccApplyProfiles_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccDumpProfile_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccFromXml_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccRoundTrip_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccSpecSepToTiff_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccTiffDump_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccToXml_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccV5DspObsToV4Dsp_d.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyNamedCmm\x64\Debug\iccApplyNamedCmm.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyProfiles\x64\Debug\iccApplyProfiles.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccDumpProfile\x64\Debug\iccDumpProfile.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccRoundTrip\x64\Debug\iccRoundTrip.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccSpecSepToTiff\x64\Debug\iccSpecSepToTiff.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccTiffDump\x64\Debug\iccTiffDump.exe",
    "C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccV5DspObsToV4Dsp\x64\Debug\iccV5DspObsToV4Dsp.exe"
)

# Remove duplicates
$exeFiles = $exeFiles | Sort-Object -Unique

# Initialize counters and lists
$totalPrograms = $exeFiles.Count
$programsWithOutput = 0
$programsWithoutOutput = 0
$filesWithOutput = @()
$filesWithoutOutput = @()

# Function to pretty print the output
function Write-PrettyOutput {
    param (
        [string]$exeFile,
        [string]$output
    )
    Write-Host ("*" * 80)
    Write-Host "Execution of: $exeFile"
    Write-Host ("-" * 80)
    Write-Host $output -NoNewline
    Write-Host
    Write-Host ("*" * 80)
    Write-Host
}

# Iterate through each .exe file
foreach ($exeFile in $exeFiles) {
    try {
        # Execute the .exe file and capture the output
        $output = & $exeFile 2>&1 | Out-String
        
        if ($output.Trim()) {
            $programsWithOutput++
            $filesWithOutput += $exeFile
            # Pretty print the output to the console
            Write-PrettyOutput -exeFile $exeFile -output $output
        } else {
            $programsWithoutOutput++
            $filesWithoutOutput += $exeFile
        }
    } catch {
        $programsWithoutOutput++
        $filesWithoutOutput += $exeFile
        # Handle errors
        Write-PrettyOutput -exeFile $exeFile -output $_.Exception.Message
    }
}

# Print summary
Write-Host ("=" * 80)
Write-Host "Summary"
Write-Host ("=" * 80)
Write-Host "Total number of programs: $totalPrograms"
Write-Host "Number of programs with output: $programsWithOutput"
Write-Host "Number of programs without output: $programsWithoutOutput"
Write-Host
Write-Host "Programs with output:"
$filesWithOutput | ForEach-Object { Write-Host $_ }
Write-Host
Write-Host "Programs without output:"
$filesWithoutOutput | ForEach-Object { Write-Host $_ }
Write-Host ("=" * 80)
```

### Expected Output
```
Total number of programs: 18
Number of programs with output: 18
Number of programs without output: 0

Programs with output:
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Debug\IccFromXml.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Debug\IccToXml.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccApplyNamedCmm_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccApplyProfiles_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccDumpProfile_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccFromXml_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccRoundTrip_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccSpecSepToTiff_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccTiffDump_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccToXml_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccV5DspObsToV4Dsp_d.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyNamedCmm\x64\Debug\iccApplyNamedCmm.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyProfiles\x64\Debug\iccApplyProfiles.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccDumpProfile\x64\Debug\iccDumpProfile.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccRoundTrip\x64\Debug\iccRoundTrip.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccSpecSepToTiff\x64\Debug\iccSpecSepToTiff.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccTiffDump\x64\Debug\iccTiffDump.exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccV5DspObsToV4Dsp\x64\Debug\iccV5DspObsToV4Dsp.exe
```
