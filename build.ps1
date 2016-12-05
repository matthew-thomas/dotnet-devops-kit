#Requires -Version 5

# This script builds a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

$ErrorActionPreference = 'Stop'

$BuildSettingsFile = 'build-settings.json'
$BuildSettings     = ConvertFrom-Json -InputObject (Get-Content -Path $BuildSettingsFile -Raw)

$BasePath                = $PSScriptRoot    # The root of the repository.
$ScriptsFolderName       = 'scripts'        # Folder containing the build scripts.

$ScriptsPath       = Join-Path $BasePath          $ScriptsFolderName
$BuildToolsPath    = Join-Path $BasePath          $BuildSettings.BuildToolsFolderName
$PsakePath         = Join-Path $BuildToolsPath    'psake.4.6.0\tools\psake.ps1'
$BuildTasksPath    = Join-Path $ScriptsPath       'build-tasks.ps1'
$NuGetPath         = Join-Path $BasePath          'NuGet.exe'
$InstallScriptPath = Join-Path $ScriptsPath       install-build-dependencies.ps1

# Install the build dependencies if they are not already.
if (-not (Test-Path $PsakePath)) {
    Write-Warning "$PsakePath not found, running install scripts..."

    & $InstallScriptPath `
        -BasePath       $BasePath `
        -BuildToolsPath $BuildToolsPath `
        -NuGetPath      $NuGetPath
}

# Execute the build tasks, passing in any additional command line arguments.
& $PsakePath `
    $BuildTasksPath `
    $args `
    -parameters @{ 
        BasePath       = "$PSScriptRoot";
        BuildToolsPath = "$BuildToolsPath";
        NuGetPath      = "$NuGetPath"; 
        BuildSettings  = $BuildSettings;
    } `
    -nologo `
    -framework $BuildSettings.DotNetFrameworkVersion

# Map psake result to process exit codes.
if ($psake.build_success) { exit 0 } else { exit 1 }