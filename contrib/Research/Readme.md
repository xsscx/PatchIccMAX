Hello -

Do you have a moment to test a powershell build script and provide feedback?

This PR Preview modifies the VS2022 Configs after installing the deps with vcpgk and builds the project with reduced friction. 

View the [Github Action Build Log](https://github.com/xsscx/DemoIccMAX/actions/runs/10311814880/job/28546363601)

Any feedback appreciated.

## Patch for VS2022 Build Files

```
PatchIccMAX % git apply --stat contrib/Research/vs2022-build-mods.patch

 Build/Cmake/CMakeLists.txt                         |    6 +-
 Build/MSVC/BuildAll_v22.sln                        |    1
 Build/MSVC/BuildAll_v22.vcxproj                    |    8 +-
 Build/MSVC/BuildDefs.props                         |    4 +
 IccXML/IccLibXML/IccLibXML_CRTDLL_v22.vcxproj      |    8 +-
 IccXML/IccLibXML/IccLibXML_v22.vcxproj             |    3 +
 .../IccApplyProfiles/iccApplyProfiles_v22.vcxproj  |    6 +-
 .../IccSpecSepToTiff/iccSpecSepToTiff_v22.vcxproj  |    6 +-
 Tools/CmdLine/IccTiffDump/iccTiffDump_v22.vcxproj  |   74 ++++++++++----------
 .../IccV5DspObsToV4Dsp_v22.vcxproj                 |    2 -
 .../wxProfileDump/wxProfileDump_v22.vcxproj        |    3 +
 11 files changed, 62 insertions(+), 59 deletions(-)
```

### Powershell 7
Paste the Powershell code into the Terminal to Build with Visual Studio 2022
```
# Set up paths
$baseDir = "C:\tmp\test\builds
"
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

# Define the directory to search
$directory = "C:\tmp\test\builds\vcpkg\PatchIccMAX"

# Get all .exe, .dll, and .lib files in the directory and subdirectories
$files = Get-ChildItem -Path $directory -Recurse -Include *.exe, *.dll, *.lib

# Create a list to store the results
$results = @()

# Loop through each file and add to results
foreach ($file in $files) {
    $results += [PSCustomObject]@{
        Path = $file.FullName
        Type = $file.Extension
    }
}

# Display the results
$results | Format-Table -AutoSize
```
## Build Results
```
Path                                                                                                      Type
----                                                                                                      ----
C:\tmp\test\builds\vcpkg\PatchIccMAX\Build\MSVC\x64\Debug_CRTDLL\IccLibXML_CRTDLL.lib                     .lib
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccProfLib\x64\Debug\IccProfLib.lib                                  .lib
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccProfLib\x64\Debug_CRTDLL\IccProfLib_CRTDLL.lib                    .lib
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccProfLib\x64\Debug_DLL\IccProfLib_DLL.dll                          .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccProfLib\x64\Debug_DLL\IccProfLib_DLL.lib                          .lib
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Debug\IccFromXml.exe                   .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Debug\iconv-2.dll                      .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Debug\liblzma.dll                      .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Debug\libxml2.dll                      .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccFromXml\x64\Debug\zlib1.dll                        .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Debug\IccToXml.exe                       .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Debug\iconv-2.dll                        .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Debug\liblzma.dll                        .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Debug\libxml2.dll                        .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\CmdLine\IccToXml\x64\Debug\zlib1.dll                          .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\IccXML\IccLibXML\x64\Debug\IccLibXml.lib                             .lib
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccApplyNamedCmm_d.exe                                       .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccApplyProfiles_d.exe                                       .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccDumpProfile_d.exe                                         .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccFromXml_d.exe                                             .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccRoundTrip_d.exe                                           .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccSpecSepToTiff_d.exe                                       .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccTiffDump_d.exe                                            .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccToXml_d.exe                                               .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\iccV5DspObsToV4Dsp_d.exe                                     .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Testing\wxProfileDump_d.exe                                          .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyNamedCmm\x64\Debug\iccApplyNamedCmm.exe        .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyProfiles\x64\Debug\iccApplyProfiles.exe        .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyProfiles\x64\Debug\jpeg62.dll                  .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyProfiles\x64\Debug\liblzma.dll                 .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyProfiles\x64\Debug\tiff.dll                    .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccApplyProfiles\x64\Debug\zlib1.dll                   .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccDumpProfile\x64\Debug\iccDumpProfile.exe            .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccRoundTrip\x64\Debug\iccRoundTrip.exe                .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccSpecSepToTiff\x64\Debug\iccSpecSepToTiff.exe        .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccSpecSepToTiff\x64\Debug\jpeg62.dll                  .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccSpecSepToTiff\x64\Debug\liblzma.dll                 .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccSpecSepToTiff\x64\Debug\tiff.dll                    .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccSpecSepToTiff\x64\Debug\zlib1.dll                   .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccTiffDump\x64\Debug\iccTiffDump.exe                  .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccTiffDump\x64\Debug\jpeg62.dll                       .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccTiffDump\x64\Debug\liblzma.dll                      .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccTiffDump\x64\Debug\tiff.dll                         .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccTiffDump\x64\Debug\zlib1.dll                        .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\CmdLine\IccV5DspObsToV4Dsp\x64\Debug\iccV5DspObsToV4Dsp.exe    .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Debug\DemoIccMAXCmm.dll                .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\Winnt\DemoIccMAXCmm\x64\Debug\DemoIccMAXCmm.lib                .lib
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\jpeg62.dll                  .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\liblzma.dll                 .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\libpng16.dll                .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\pcre2-16.dll                .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\tiff.dll                    .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\wxbase32u_vc_custom.dll     .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\wxmsw32u_core_vc_custom.dll .dll
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\wxProfileDump.exe           .exe
C:\tmp\test\builds\vcpkg\PatchIccMAX\Tools\wxWidget\wxProfileDump\vc_mswd_x64\zlib1.dll                   .dll
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
