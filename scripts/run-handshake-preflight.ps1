param(
    [switch]$RequireGameplayMedia,
    [switch]$SkipGameplayMedia
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

$failed = $false

function Ok([string]$msg) {
    Write-Host "OK:   $msg" -ForegroundColor Green
}

function Warn([string]$msg) {
    Write-Host "WARN: $msg" -ForegroundColor Yellow
}

function Fail([string]$msg) {
    Write-Host "FAIL: $msg" -ForegroundColor Red
    $script:failed = $true
}

# 1) Structure gate
try {
    ./scripts/validate-structure.ps1 | Out-Null
    Ok "Structure validation passed"
} catch {
    Fail "Structure validation failed"
}

# 2) Required tags
$requiredTags = @(
    "godot-signal-chase-v0.3.2",
    "defold-pulse-grid-v0.2.0",
    "solar2d-spark-catch-v0.2.1",
    "panda3d-lane-drift-v0.1.0",
    "stride-lane-surge-v0.1.0"
)

foreach ($tag in $requiredTags) {
    $exists = git tag --list $tag
    if ([string]::IsNullOrWhiteSpace($exists)) {
        Fail "Missing git tag: $tag"
    } else {
        Ok "Tag exists: $tag"
    }
}

# 3) Required release notes
$requiredNotes = @(
    "docs/portfolio/release-notes/godot-signal-chase-v0.3.2.md",
    "docs/portfolio/release-notes/defold-pulse-grid-v0.2.0.md",
    "docs/portfolio/release-notes/solar2d-spark-catch-v0.2.1.md",
    "docs/portfolio/release-notes/panda3d-lane-drift-v0.1.0.md",
    "docs/portfolio/release-notes/stride-lane-surge-v0.1.0.md"
)

foreach ($path in $requiredNotes) {
    if (Test-Path $path) {
        Ok "Release notes found: $path"
    } else {
        Fail "Missing release notes: $path"
    }
}

# 4) Profiling gate
./scripts/check-profiling-readiness.ps1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Ok "Profiling readiness passed"
} else {
    Fail "Profiling readiness failed"
}

# 5) Token check for release publishing
if ([string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)) {
    Warn "GITHUB_TOKEN is not set (release pages cannot be auto-published in this shell)"
} else {
    Ok "GITHUB_TOKEN is present"
}

# 6) Gameplay media gate (enforced by default)
if (-not $SkipGameplayMedia) {
    ./scripts/check-gameplay-media-readiness.ps1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Ok "Gameplay media readiness passed"
    } else {
        Fail "Gameplay media readiness failed"
    }
} else {
    Warn "Gameplay media gate skipped (pass without -SkipGameplayMedia to enforce)"
}

Write-Host ""
if ($failed) {
    Write-Host "Handshake preflight FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "Handshake preflight PASSED" -ForegroundColor Green
exit 0
