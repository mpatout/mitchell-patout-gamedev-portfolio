param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

$requiredClips = @(
    "docs/portfolio/evidence/gameplay/godot/gameplay.mp4",
    "docs/portfolio/evidence/gameplay/defold/gameplay.mp4",
    "docs/portfolio/evidence/gameplay/solar2d/gameplay.mp4"
)

$failed = $false

foreach ($clip in $requiredClips) {
    if (Test-Path $clip) {
        Write-Host "OK:   Found clip $clip" -ForegroundColor Green
    } else {
        Write-Host "FAIL: Missing clip $clip" -ForegroundColor Red
        $failed = $true
    }
}

Write-Host ""
if ($failed) {
    Write-Host "Gameplay media readiness FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "Gameplay media readiness PASSED" -ForegroundColor Green
exit 0
