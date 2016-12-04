#Requires -Version 5

# This script builds a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

.\build-packages\psake.4.6.0\tools\psake .\build-tasks.ps1 $args -parameters @{BasePath=$PSScriptRoot} -nologo -framework 4.5.2

if ($psake.build_success) {
    exit 0
} else {
    exit 1
}