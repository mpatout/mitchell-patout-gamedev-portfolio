# engines/defold/scripts/package-release.ps1
# Packages Defold source files into a distributable zip.

param(
    [Parameter(Mandatory=$true)][string]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$stagingDir = "engines/defold/releases/.staging"
$outDir     = "engines/defold/releases"
$artifact   = "$outDir/defold-pulse-grid-v$Version-source.zip"

if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
New-Item $stagingDir -ItemType Directory | Out-Null
if (-not (Test-Path $outDir)) { New-Item $outDir -ItemType Directory | Out-Null }

$files = @(
    "engines/defold/game.project",
    "engines/defold/input/game.input_binding",
    "engines/defold/main/main.collection",
    "engines/defold/main/game.go",
    "engines/defold/main/game.gui",
    "engines/defold/main/game.gui_script",
    "engines/defold/README.md",
    "engines/defold/PROJECT_SCOPE.md",
    "engines/defold/TECHNICAL_PACKET.md",
    "engines/defold/CHANGELOG.md",
    "engines/defold/ASSET_PROVENANCE.md"
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
