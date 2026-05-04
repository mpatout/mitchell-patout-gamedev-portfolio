# engines/defold/scripts/quality-gate.ps1
# Validates Defold project structure, config correctness, and packages a CI
# preview artifact.  Mirrors the Godot quality-gate contract so the root
# CI workflow can call it identically.

param([switch]$Verbose)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $root

$pass = $true
function Fail([string]$msg) { Write-Host "FAIL: $msg" -ForegroundColor Red;   $script:pass = $false }
function Ok  ([string]$msg) { Write-Host "OK:   $msg" -ForegroundColor Green }

# ---------------------------------------------------------------------------
# 1. Required file presence
# ---------------------------------------------------------------------------
$required = @(
    "engines/defold/game.project",
    "engines/defold/input/game.input_binding",
    "engines/defold/main/main.collection",
    "engines/defold/main/game.go",
    "engines/defold/main/game.gui",
    "engines/defold/main/game.gui_script",
    "engines/defold/README.md",
    "engines/defold/PROJECT_SCOPE.md",
    "engines/defold/TECHNICAL_PACKET.md",
    "engines/defold/PROFILING_BASELINE.md",
    "engines/defold/RELEASE_RUNBOOK.md",
    "engines/defold/CHANGELOG.md",
    "engines/defold/ASSET_PROVENANCE.md",
    "engines/defold/scripts/package-release.ps1"
)
foreach ($f in $required) {
    if (Test-Path $f) { Ok "Found $f" } else { Fail "Missing $f" }
}

# ---------------------------------------------------------------------------
# 2. game.project config validation
# ---------------------------------------------------------------------------
$proj = Get-Content "engines/defold/game.project" -Raw
if ($proj -match "main_collection\s*=\s*/main/main\.collection") {
    Ok "game.project bootstrap points to /main/main.collection"
} else {
    Fail "game.project missing expected bootstrap path"
}
if ($proj -match "game_binding\s*=\s*/input/game\.input_binding") {
    Ok "game.project input binding configured"
} else {
    Fail "game.project missing input binding reference"
}

# ---------------------------------------------------------------------------
# 3. Collection → game object link
# ---------------------------------------------------------------------------
$col = Get-Content "engines/defold/main/main.collection" -Raw
if ($col -match 'prototype.*"/main/game\.go"') {
    Ok "main.collection references game.go"
} else {
    Fail "main.collection does not reference game.go"
}

# ---------------------------------------------------------------------------
# 4. Game object → GUI component link
# ---------------------------------------------------------------------------
$go = Get-Content "engines/defold/main/game.go" -Raw
if ($go -match 'component.*"/main/game\.gui"') {
    Ok "game.go references game.gui"
} else {
    Fail "game.go does not reference game.gui"
}

# ---------------------------------------------------------------------------
# 5. GUI script referencing gui_script
# ---------------------------------------------------------------------------
$gui = Get-Content "engines/defold/main/game.gui" -Raw
if ($gui -match 'script.*"/main/game\.gui_script"') {
    Ok "game.gui references game.gui_script"
} else {
    Fail "game.gui does not reference game.gui_script"
}

# ---------------------------------------------------------------------------
# 6. Package preview artifact
# ---------------------------------------------------------------------------
./engines/defold/scripts/package-release.ps1 -Version "ci-preview"
$artifact = "engines/defold/releases/defold-pulse-grid-vci-preview-source.zip"
if (Test-Path $artifact) { Ok "CI preview artifact created" } else { Fail "Artifact not created at $artifact" }

# ---------------------------------------------------------------------------
# Result
# ---------------------------------------------------------------------------
Write-Host ""
if ($pass) {
    Write-Host "Quality gate PASSED" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "Quality gate FAILED — review errors above" -ForegroundColor Red
    exit 1
}
