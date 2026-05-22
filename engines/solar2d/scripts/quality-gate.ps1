# engines/solar2d/scripts/quality-gate.ps1
# Validates Solar2D project structure and packages a CI preview artifact.

param([switch]$Verbose)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$pass = $true
function Fail([string]$msg) { Write-Host "FAIL: $msg" -ForegroundColor Red; $script:pass = $false }
function Ok([string]$msg) { Write-Host "OK:   $msg" -ForegroundColor Green }

$required = @(
    "engines/solar2d/config.lua",
    "engines/solar2d/main.lua",
    "engines/solar2d/README.md",
    "engines/solar2d/PROJECT_SCOPE.md",
    "engines/solar2d/TECHNICAL_PACKET.md",
    "engines/solar2d/PROFILING_BASELINE.md",
    "engines/solar2d/ACCEPTANCE_TEST.md",
    "engines/solar2d/RELEASE_RUNBOOK.md",
    "engines/solar2d/CHANGELOG.md",
    "engines/solar2d/ASSET_PROVENANCE.md",
    "engines/solar2d/scripts/package-release.ps1",
    "engines/solar2d/scripts/summarize-trace.ps1"
)

foreach ($f in $required) {
    if (Test-Path $f) { Ok "Found $f" } else { Fail "Missing $f" }
}

./engines/solar2d/scripts/package-release.ps1 -Version "ci-preview"
$artifact = "engines/solar2d/releases/solar2d-spark-catch-vci-preview-source.zip"
if (Test-Path $artifact) { Ok "CI preview artifact created" } else { Fail "Artifact not created at $artifact" }

Write-Host ""
if ($pass) {
    Write-Host "Quality gate PASSED" -ForegroundColor Cyan
    exit 0
}

Write-Host "Quality gate FAILED - review errors above" -ForegroundColor Red
exit 1
