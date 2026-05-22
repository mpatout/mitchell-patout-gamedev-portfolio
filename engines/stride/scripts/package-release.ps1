# engines/stride/scripts/package-release.ps1
# Packages Stride baseline source files into a distributable zip.

param(
    [Parameter(Mandatory = $true)][string]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$stagingDir = "engines/stride/releases/.staging"
$outDir = "engines/stride/releases"
$artifact = "$outDir/stride-lane-surge-v$Version-source.zip"

if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
New-Item $stagingDir -ItemType Directory | Out-Null
if (-not (Test-Path $outDir)) { New-Item $outDir -ItemType Directory | Out-Null }

$files = @(
    "engines/stride/src/LaneSurge/LaneSurge.csproj",
    "engines/stride/src/LaneSurge/Program.cs",
    "engines/stride/README.md",
    "engines/stride/PROJECT_SCOPE.md",
    "engines/stride/TECHNICAL_PACKET.md",
    "engines/stride/PROFILING_BASELINE.md",
    "engines/stride/ACCEPTANCE_TEST.md",
    "engines/stride/RELEASE_RUNBOOK.md",
    "engines/stride/CHANGELOG.md",
    "engines/stride/ASSET_PROVENANCE.md"
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
