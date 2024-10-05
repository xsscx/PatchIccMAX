@echo off
setlocal enabledelayedexpansion

:: Load the JSON configuration using jq (jq must be installed)
for /f "tokens=*" %%i in ('jq -r ".msbuild_path" vs2022_build_config.json') do set msbuild_path=%%i
for /f "tokens=*" %%i in ('jq -r ".solution_file" vs2022_build_config.json') do set solution_file=%%i
for /f "tokens=*" %%i in ('jq -r ".build_options.max_cpu_count" vs2022_build_config.json') do set max_cpu_count=%%i
for /f "tokens=*" %%i in ('jq -r ".build_options.configurations[0].compiler_options" vs2022_build_config.json') do set compiler_options=%%i
for /f "tokens=*" %%i in ('jq -r ".build_options.configurations[0].linker_options" vs2022_build_config.json') do set linker_options=%%i

:: Set environment variables from the JSON (using jq)
for /f "tokens=2 delims=: " %%i in ('jq -r ".environment_variables | to_entries | .[].key" vs2022_build_config.json') do (
    set /p env_key=%%i
    for /f "tokens=*" %%j in ('jq -r ".environment_variables.%%i" vs2022_build_config.json') do set %%i=%%j
)

:: Run MSBuild
echo Starting build process...
%msbuild_path% /m %max_cpu_count% /t:Clean,Build /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories=%include_dirs% /p:AdditionalLibraryDirectories=%library_dirs% /p:CLToolAdditionalOptions="%compiler_options%" /p:LinkToolAdditionalOptions="%linker_options%" %solution_file%

:: Check if MSBuild succeeded or failed
if %ERRORLEVEL% equ 0 (
    echo Build succeeded.
) else (
    echo Build failed with exit code %ERRORLEVEL%.
)

endlocal
