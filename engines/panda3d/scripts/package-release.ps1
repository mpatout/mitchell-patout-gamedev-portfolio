# engines/panda3d/scripts/package-release.ps1
# Packages Panda3D source files into a distributable zip.

param(
    [Parameter(Mandatory = $true)][string]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$stagingDir = "engines/panda3d/releases/.staging"
$outDir = "engines/panda3d/releases"
$artifact = "$outDir/panda3d-lane-drift-v$Version-source.zip"

if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
New-Item $stagingDir -ItemType Directory | Out-Null
if (-not (Test-Path $outDir)) { New-Item $outDir -ItemType Directory | Out-Null }

$files = @(
    "engines/panda3d/main.py",
    "engines/panda3d/requirements.txt",
    "engines/panda3d/README.md",
    "engines/panda3d/PROJECT_SCOPE.md",
    "engines/panda3d/TECHNICAL_PACKET.md",
    "engines/panda3d/PROFILING_BASELINE.md",
    "engines/panda3d/ACCEPTANCE_TEST.md",
    "engines/panda3d/RELEASE_RUNBOOK.md",
    "engines/panda3d/CHANGELOG.md",
    "engines/panda3d/ASSET_PROVENANCE.md"
)

foreach ($f in $files) {
    $dest = Join-Path $stagingDir $f
    $destDir = Split-Path $dest
    if (-not (Test-Path $destDir)) { New-Item $destDir -ItemType Directory | Out-Null }
    Copy-Item $f $dest
}

if (Test-Path $artifact) { Remove-Item $artifact -Force }
Compress-Archive -Path "$stagingDir/*" -DestinationPath $artifact
Remove-Item $stagingDir -Recurse -Force

Write-Host "Packaged: $artifact" -ForegroundColor Green
