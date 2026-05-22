# engines/panda3d/scripts/quality-gate.ps1
# Validates Panda3D project structure and packages a CI preview artifact.

param([switch]$Verbose)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$pass = $true
function Fail([string]$msg) { Write-Host "FAIL: $msg" -ForegroundColor Red; $script:pass = $false }
function Ok([string]$msg) { Write-Host "OK:   $msg" -ForegroundColor Green }

$required = @(
    "engines/panda3d/main.py",
    "engines/panda3d/requirements.txt",
    "engines/panda3d/README.md",
    "engines/panda3d/PROJECT_SCOPE.md",
    "engines/panda3d/TECHNICAL_PACKET.md",
    "engines/panda3d/PROFILING_BASELINE.md",
    "engines/panda3d/ACCEPTANCE_TEST.md",
    "engines/panda3d/RELEASE_RUNBOOK.md",
    "engines/panda3d/CHANGELOG.md",
    "engines/panda3d/ASSET_PROVENANCE.md",
    "engines/panda3d/scripts/package-release.ps1"
)

foreach ($f in $required) {
    if (Test-Path $f) { Ok "Found $f" } else { Fail "Missing $f" }
}

./engines/panda3d/scripts/package-release.ps1 -Version "ci-preview"
$artifact = "engines/panda3d/releases/panda3d-lane-drift-vci-preview-source.zip"
if (Test-Path $artifact) { Ok "CI preview artifact created" } else { Fail "Artifact not created at $artifact" }

Write-Host ""
if ($pass) {
    Write-Host "Quality gate PASSED" -ForegroundColor Cyan
    exit 0
}

Write-Host "Quality gate FAILED - review errors above" -ForegroundColor Red
exit 1
