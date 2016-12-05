#Requires -Version 5

# This script installs dependencies needed to build a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

$ErrorActionPreference = 'Stop'

# Configure folder names
$BasePath

$BuildToolsBinariesFolderName = '.tools' # The folder containing tools for building a release.

$BuildOutputPath              = Join-Path $BasePath $BuildOutputFolderName
$BuildToolsBinariesPath       = Join-Path $BasePath $BuildToolsBinariesFolderName
$NuGetPath                    = Join-Path $BasePath 'NuGet.exe'
$BuildToolsPackagesConfigPath = Join-Path $BasePath 'packages.build-tools.config' 

# Restore all build tools
& $NuGetPath Restore $BuildToolsPackagesConfigPath -PackagesDirectory $BuildToolsBinariesPath