#Requires -Version 5

# This script contains reusable functions related to building releases.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

$ErrorActionPreference = 'Stop'

<#  
    .Synopsis
    Executes tests within the specified .NET libraries.
    
    .PARAMETER InputPackagesPath
    Specifies the path where build tool packages can be found.

    .PARAMETER ArtifactsPath
    Specifies the path where output artifacts can be found.

    .PARAMETER TestDlls
    Specifies a collection of paths to DLLs containing .NET tests.
#>
function Run-DotNet-Tests {
    [CmdletBinding()]
    Param(
        [string]
        [Parameter(Mandatory=$true)]
        $InputPackagesPath,

        [string]
        [Parameter(Mandatory=$true)]
        $ArtifactsPath,
        
        [Parameter(Mandatory=$true)]
        $TestDlls
    )

    Process {
        $xUnitPath = Join-Path $InputPackagesPath 'xunit.runner.console.2.1.0\tools\xunit.console.exe'

        exec { & $xUnitPath $TestDlls }
    }
}