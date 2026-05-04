$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptDir "..")
$repoRoot = Resolve-Path (Join-Path $projectRoot "..\..")

Set-Location $repoRoot

$required = @(
    "engines/godot/project.godot",
    "engines/godot/scenes/Main.tscn",
    "engines/godot/scripts/main.gd",
    "engines/godot/README.md",
    "engines/godot/PROJECT_SCOPE.md",
    "engines/godot/TECHNICAL_PACKET.md",
    "engines/godot/PROFILING_BASELINE.md",
    "engines/godot/RELEASE_RUNBOOK.md",
    "engines/godot/CHANGELOG.md",
    "engines/godot/ASSET_PROVENANCE.md",
    "engines/godot/scripts/package-release.ps1"
)

$missing = @()
foreach ($path in $required) {
    if (-not (Test-Path $path)) {
        $missing += $path
    }
}

if ($missing.Count -gt 0) {
    Write-Host "Missing Godot production files:" -ForegroundColor Red
    $missing | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

./engines/godot/scripts/package-release.ps1 -Version "ci-preview"

$artifact = "engines/godot/releases/godot-signal-chase-vci-preview-source.zip"
if (-not (Test-Path $artifact)) {
    Write-Host "Expected artifact not found: $artifact" -ForegroundColor Red
    exit 1
}

Write-Host "Godot quality gate passed." -ForegroundColor Green
