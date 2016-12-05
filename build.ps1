#Requires -Version 5

# This script builds a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

$ErrorActionPreference = 'Stop'

$BasePath                = $PSScriptRoot
$BuildToolsFolderName   = '.tools'
$ScriptsFolderName       = 'scripts'
$BuildPackagesFolderName = 'packages'

$ScriptsPath       = Join-Path $BasePath          $ScriptsFolderName
$BuildToolsPath    = Join-Path $BasePath          $BuildToolsFolderName
$PsakePath         = Join-Path $BuildToolsPath    'psake.4.6.0\tools\psake'
$BuildTasksPath    = Join-Path $ScriptsFolderName 'build-tasks.ps1'

# Install the build dependencies if they are not already.
if (-not (Test-Path $PsakePath)) {
    Write-Warning 'Psake not found, running install scripts...'

    $InstallScriptPath = Join-Path $ScriptsPath install-build-dependencies.ps1

    & $InstallScriptPath -BasePath $BasePath
}

# Execute the build tasks, passing in any additional command line arguments.
& $PsakePath `
    $BuildTasksPath `
    $args `
    -parameters @{ BasePath = $PSScriptRoot } `
    -nologo `
    -framework 4.5.2

# Map psake result to process exit codes.
if ($psake.build_success) { exit 0 } else { exit 1 }