# Load the JSON configuration
$jsonConfig = Get-Content -Raw -Path "vs2022_build_config.json" | ConvertFrom-Json

# Set environment variables from the JSON if required
foreach ($key in $jsonConfig.environment_variables.PSObject.Properties.Name) {
    $env:$key = $jsonConfig.environment_variables.$key
}

# Define MSBuild path and common build parameters from JSON
$msbuildPath = $jsonConfig.msbuild_path
$solutionFile = $jsonConfig.solution_file
$maxCpuCount = $jsonConfig.build_options.max_cpu_count
$includeDirs = $jsonConfig.build_options.additional_include_directories
$libraryDirs = $jsonConfig.build_options.additional_library_directories
$binaryLogging = $jsonConfig.build_options.binary_logging

# Ask the user to select Configuration and Platform
$configOptions = $jsonConfig.build_options.configurations
$selectedConfig = $null

Write-Host "Available configurations:"
for ($i = 0; $i -lt $configOptions.Count; $i++) {
    Write-Host "$($i + 1): $($configOptions[$i].name) ($($configOptions[$i].platform))"
}

# Prompt for selection
$selection = Read-Host "Enter the number for the desired configuration"
$selectedConfig = $configOptions[$selection - 1]

# Extract selected configuration parameters
$configuration = $selectedConfig.name
$platform = $selectedConfig.platform
$compilerOptions = $selectedConfig.compiler_options
$linkerOptions = $selectedConfig.linker_options

# Run MSBuild with the selected configuration
Write-Host "Starting MSBuild with configuration: $configuration, platform: $platform..."
& $msbuildPath /m $maxCpuCount /t:Rebuild /p:Configuration=$configuration /p:Platform=$platform /p:AdditionalIncludeDirectories=$includeDirs /p:AdditionalLibraryDirectories=$libraryDirs /p:CLToolAdditionalOptions="$compilerOptions" /p:LinkToolAdditionalOptions="$linkerOptions" $solutionFile $binaryLogging

# Check the exit code of MSBuild to determine if it succeeded or failed
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build succeeded."
} else {
    Write-Host "Build failed with exit code $LASTEXITCODE."
}
