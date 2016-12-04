#Requires -Version 5

# This script installs dependencies needed to build a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

$ErrorActionPreference='Stop'

# Configure folder names
$BuildToolsBinariesFolderName = 'build-tools'    # The folder containing tools for building a release.
$BuildToolsPackagesFolderName = 'build-packages' # The folder containing NuGet downloaded packages.

$RootPath                     = Get-Location
$BuildToolsBinariesPath       = Join-Path $RootPath               $BuildToolsBinariesFolderName
$NuGetPath                    = Join-Path $BuildToolsBinariesPath 'NuGet.exe'
$BuildToolsPackagesConfigPath = Join-Path $RootPath               'packages.build-tools.config' 
$BuildToolsPackagesPath       = Join-Path $RootPath               $BuildToolsPackagesFolderName

# Restore all build tools
& $NuGetPath Restore $BuildToolsPackagesConfigPath -PackagesDirectory $BuildToolsPackagesPath