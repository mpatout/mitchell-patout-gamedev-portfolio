# engines/solar2d/scripts/package-release.ps1
# Packages Solar2D source files into a distributable zip.

param(
    [Parameter(Mandatory = $true)][string]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$stagingDir = "engines/solar2d/releases/.staging"
$outDir = "engines/solar2d/releases"
$artifact = "$outDir/solar2d-spark-catch-v$Version-source.zip"

if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
New-Item $stagingDir -ItemType Directory | Out-Null
if (-not (Test-Path $outDir)) { New-Item $outDir -ItemType Directory | Out-Null }

$files = @(
    "engines/solar2d/config.lua",
    "engines/solar2d/main.lua",
    "engines/solar2d/README.md",
    "engines/solar2d/PROJECT_SCOPE.md",
    "engines/solar2d/TECHNICAL_PACKET.md",
    "engines/solar2d/PROFILING_BASELINE.md",
    "engines/solar2d/ACCEPTANCE_TEST.md",
    "engines/solar2d/RELEASE_RUNBOOK.md",
    "engines/solar2d/CHANGELOG.md",
    "engines/solar2d/ASSET_PROVENANCE.md"
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
