#Requires -Version 5

# This script installs dependencies needed to build a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

$ErrorActionPreference = 'Stop'

# Configure folder names
$BasePath

$BuildOutputPath              = Join-Path $BasePath $BuildOutputFolderName
$BuildToolsPackagesConfigPath = Join-Path $BasePath 'packages.build-tools.config' 

# Restore all build tools
& $NuGetPath Restore $BuildToolsPackagesConfigPath -PackagesDirectory $BuildToolsPath