#Requires -Version 5

# This script builds a release.
# Following this style guide: https://github.com/PoshCode/PowerShellPracticeAndStyle

# Define path parameters
$BasePath = "Uninitialized" # Caller must specify.

# Define the input properties and their default values.
properties {
    $ProductName           = "PRODUCT"
    $SolutionFileName      = "$ProductName.sln"
    $SourcePath            = Join-Path $BasePath        "src"
    $ArtifactsPath         = Join-Path $BasePath        "dist"    
    $PackagesPath          = Join-Path $SourcePath      "packages"
    $SolutionPath          = Join-Path $SourcePath      $SolutionFileName
}

# Define the Task to call when none was specified by the caller.
Task Default -depends CreateRelease

Task Clean -Description 'Removes any output left from previous builds.' {
    if (Test-Path $ArtifactsPath) {
        Remove-Item `
            $ArtifactsPath `
            -Force `
            -Recurse
    }
}

Task Build -Depends Clean -Description 'Compiles the solution.' {
    # Create the artifacts directory if it doesn't exist.
    New-Item `
        -Path     $ArtifactsPath `
        -ItemType Directory |
            Out-Null

    exec { msbuild $SolutionPath }
}

Task UnitTest -Depends Build -Description 'Unit tests the compiled code.' {
}

Task CreateRelease -Depends UnitTest -Description 'Creates a release.' {
    $DeployScriptPath = Join-Path $SourcePath deploy.ps1

    Copy-Item `
        -Path           $DeployScriptPath `
        -Destination    $ArtifactsPath
}