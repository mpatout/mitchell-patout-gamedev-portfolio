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

$projectConfig = Get-Content "engines/godot/project.godot" -Raw
if ($projectConfig -notmatch 'run/main_scene="res://scenes/Main.tscn"') {
    Write-Host "Invalid run/main_scene in engines/godot/project.godot" -ForegroundColor Red
    exit 1
}

if ($projectConfig -notmatch 'config/features=PackedStringArray\("4\.2\.2"\)') {
    Write-Host "Expected tested feature version 4.2.2 in project.godot" -ForegroundColor Red
    exit 1
}

$sceneText = Get-Content "engines/godot/scenes/Main.tscn" -Raw
if ($sceneText -notmatch 'path="res://scripts/main.gd"') {
    Write-Host "Main scene does not reference scripts/main.gd" -ForegroundColor Red
    exit 1
}

./engines/godot/scripts/package-release.ps1 -Version "ci-preview"

$artifact = "engines/godot/releases/godot-signal-chase-vci-preview-source.zip"
if (-not (Test-Path $artifact)) {
    Write-Host "Expected artifact not found: $artifact" -ForegroundColor Red
    exit 1
}

if (Get-Command godot4 -ErrorAction SilentlyContinue) {
    Write-Host "godot4 detected. Running headless smoke check..." -ForegroundColor Cyan
    godot4 --path "engines/godot" --headless --quit | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Headless smoke check failed." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "godot4 not detected in PATH; runtime smoke check skipped." -ForegroundColor Yellow
}

Write-Host "Godot quality gate passed." -ForegroundColor Green
