﻿$packageFile = "Source\Core\BuildVisionPackage.Package.cs"
$manifestFile = "Source\source.extension.vsixmanifest"
$appveyorFile = "appveyor.yml"

If ($env:APPVEYOR)
{
    $version = $env:APPVEYOR_BUILD_VERSION
    echo "Version $version"
}
Else
{
    $msg = 'Enter a new version in 0.0.0 format (or enter nothing to exit)'
    $version = (Read-Host $msg).Trim()
    if(!$version)
    { 
        echo "Aborted."
        Exit 
    }

    (Get-Content $appveyorFile) `
        -replace '(version: )[0-9.]*(\.{build})', "`${1}$version`$2" |
      Out-File $appveyorFile
}

(Get-Content $packageFile) `
    -replace '(PackageVersion) = "[0-9.]*"', "`${1} = ""$version""" |
  Out-File $packageFile

(Get-Content $manifestFile) `
    -replace '(<Version>)[0-9.]*', "`${1}$version" |
  Out-File $manifestFile

echo "Done."
