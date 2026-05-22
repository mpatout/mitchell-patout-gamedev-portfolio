# engines/stride/scripts/quality-gate.ps1
# Validates Stride baseline structure and packages a CI preview artifact.

param([switch]$Verbose)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$pass = $true
function Fail([string]$msg) { Write-Host "FAIL: $msg" -ForegroundColor Red; $script:pass = $false }
function Ok([string]$msg) { Write-Host "OK:   $msg" -ForegroundColor Green }

$required = @(
    "engines/stride/src/LaneSurge/LaneSurge.csproj",
    "engines/stride/src/LaneSurge/Program.cs",
    "engines/stride/README.md",
    "engines/stride/PROJECT_SCOPE.md",
    "engines/stride/TECHNICAL_PACKET.md",
    "engines/stride/PROFILING_BASELINE.md",
    "engines/stride/ACCEPTANCE_TEST.md",
    "engines/stride/RELEASE_RUNBOOK.md",
    "engines/stride/CHANGELOG.md",
    "engines/stride/ASSET_PROVENANCE.md",
    "engines/stride/scripts/package-release.ps1"
)

foreach ($f in $required) {
    if (Test-Path $f) { Ok "Found $f" } else { Fail "Missing $f" }
}

./engines/stride/scripts/package-release.ps1 -Version "ci-preview"
$artifact = "engines/stride/releases/stride-lane-surge-vci-preview-source.zip"
if (Test-Path $artifact) { Ok "CI preview artifact created" } else { Fail "Artifact not created at $artifact" }

Write-Host ""
if ($pass) {
    Write-Host "Quality gate PASSED" -ForegroundColor Cyan
    exit 0
}

Write-Host "Quality gate FAILED - review errors above" -ForegroundColor Red
exit 1
