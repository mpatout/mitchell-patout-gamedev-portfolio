param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

$baselineFiles = @(
    "engines/Godot/PROFILING_BASELINE.md",
    "engines/defold/PROFILING_BASELINE.md",
    "engines/solar2d/PROFILING_BASELINE.md"
)

$screenshotRequirements = @(
    "docs/portfolio/evidence/profiling/godot/low-pressure.png",
    "docs/portfolio/evidence/profiling/godot/high-pressure.png",
    "docs/portfolio/evidence/profiling/defold/low-pressure.png",
    "docs/portfolio/evidence/profiling/defold/high-pressure.png",
    "docs/portfolio/evidence/profiling/solar2d/low-pressure.png",
    "docs/portfolio/evidence/profiling/solar2d/high-pressure.png"
)

$failed = $false

foreach ($file in $baselineFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "FAIL: Missing baseline file $file" -ForegroundColor Red
        $failed = $true
        continue
    }

    $content = Get-Content $file -Raw
    if ($content -match "Pending") {
        Write-Host "FAIL: Pending values remain in $file" -ForegroundColor Red
        $failed = $true
    } else {
        Write-Host "OK:   No Pending values in $file" -ForegroundColor Green
    }
}

foreach ($path in $screenshotRequirements) {
    if (-not (Test-Path $path)) {
        Write-Host "FAIL: Missing screenshot $path" -ForegroundColor Red
        $failed = $true
    } else {
        Write-Host "OK:   Found screenshot $path" -ForegroundColor Green
    }
}

Write-Host ""
if ($failed) {
    Write-Host "Profiling readiness FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "Profiling readiness PASSED" -ForegroundColor Green
exit 0
