#Requires -Version 5

# This script builds a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

$ErrorActionPreference = 'Stop'

Include build-functions.ps1

# Define some constants
$BasePath                       = 'Uninitialized'   # Caller must specify the base path, all other paths will be relative to it.

# Define the input properties and their default values.
properties {
    $ProductName                    = 'ExampleApp'                                        # Name of the product.
    $SolutionFileName               = "$ProductName.sln"                                  # Name of the application solution file.
    $SourcePath                     = Join-Path $BasePath           'src'                         # Full path to the application source code.
    $SolutionPath                   = Join-Path $SourcePath         $SolutionFileName             # Full path to the application solution file.
    $BuildOutputPath                = Join-Path $BasePath           '.build'                      # Full path to all the intermediate build output.
    $BuildToolsPath
    $NuGetPath                      = Join-Path $BasePath           'NuGet.exe'       # Full path to NuGet.exe.
}

# Define the Task to call when none was specified by the caller.
Task Default -depends CreateRelease

Task Clean `
    -Description 'Removes any output left from previous builds.' {
    if (Test-Path $BuildOutputPath) {
        Remove-Item `
            $BuildOutputPath `
                -Force `
                -Recurse
    }
}

Task Build `
    -Depends     Clean `
    -Description 'Compiles the solution.' {
    Set-Location $SourcePath
    
    exec { & $NuGetPath restore }

    Set-Location $BasePath

    Write-Host "Building '$SolutionPath'..."
    exec { & msbuild $SolutionPath /p:OutDir="$BuildOutputPath"  }
}

Task UnitTest `
    -Depends     Build `
    -Description 'Unit tests the code.' {
    # Run-Db-Tests
    # Run-JavaScript-Tests

    $DotNetDllPattern = "$BuildOutputPath\*.Test.Unit.dll"

    Write-Host "Searching '$DotNetDllPattern' for tests..."

    $DotNetTestDLLs = Get-Item $DotNetDllPattern

    Write-Host $DotNetTestDLLs.Count test dlls found.

    Run-DotNet-Tests `
        -InputPackagesPath $BuildToolsPath `
        -ArtifactsPath     $BuildOutputPath `
        -TestDlls          $DotNetTestDLLs
}

Task CreateRelease `
    -Depends     UnitTest `
    -Description 'Creates a release.' {
    $DeployScriptPath = Join-Path $SourcePath deploy.ps1

    Copy-Item `
        -Path           $DeployScriptPath `
        -Destination    $BuildOutputPath
}