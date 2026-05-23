param(
    [ValidateSet("all", "godot", "defold", "solar2d")]
    [string]$Engine = "all",
    [switch]$OpenPaths,
    [switch]$RunGate
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

function Header([string]$text) {
    Write-Host "" 
    Write-Host $text -ForegroundColor Cyan
}

function Bullet([string]$text) {
    Write-Host "- $text"
}

function ShowEnginePlan([string]$name, [string]$baseline, [string]$lowPath, [string]$highPath, [string[]]$steps) {
    Header "[$name]"
    Bullet "Baseline doc: $baseline"
    Bullet "Low-pressure screenshot: $lowPath"
    Bullet "High-pressure screenshot: $highPath"
    Bullet "Capture steps:"
    foreach ($step in $steps) {
        Write-Host "  * $step"
    }

    if ($OpenPaths) {
        $lowDir = Split-Path $lowPath -Parent
        if (Test-Path $lowDir) {
            Invoke-Item $lowDir
        }
    }
}

Header "Profiling Capture Sprint"
Bullet "Repository root: $repoRoot"
Bullet "Goal: remove all Pending values and add six screenshots"

$selected = @()
if ($Engine -eq "all") {
    $selected = @("godot", "defold", "solar2d")
} else {
    $selected = @($Engine)
}

foreach ($target in $selected) {
    switch ($target) {
        "godot" {
            ShowEnginePlan -name "Godot" -baseline "engines/Godot/PROFILING_BASELINE.md" -lowPath "docs/portfolio/evidence/profiling/godot/low-pressure.png" -highPath "docs/portfolio/evidence/profiling/godot/high-pressure.png" -steps @(
                    "Open engines/Godot in Godot 4.2.2",
                    "Capture low-pressure profiler window at level 1",
                    "Capture high-pressure profiler window at level 5+",
                    "Record FPS range and largest spike in baseline doc"
                )
        }
        "defold" {
            ShowEnginePlan -name "Defold" -baseline "engines/defold/PROFILING_BASELINE.md" -lowPath "docs/portfolio/evidence/profiling/defold/low-pressure.png" -highPath "docs/portfolio/evidence/profiling/defold/high-pressure.png" -steps @(
                    "Open engines/defold in Defold Editor",
                    "Enable Debug -> Toggle Profile",
                    "Capture low pressure at start and high pressure at level 6+",
                    "Record frame time and script self-time in baseline doc"
                )
        }
        "solar2d" {
            ShowEnginePlan -name "Solar2D" -baseline "engines/solar2d/PROFILING_BASELINE.md" -lowPath "docs/portfolio/evidence/profiling/solar2d/low-pressure.png" -highPath "docs/portfolio/evidence/profiling/solar2d/high-pressure.png" -steps @(
                    "Open engines/solar2d in Solar2D Simulator",
                    "Capture metrics in first 10s (low pressure)",
                    "Capture metrics at level 6+ or active overcharge (high pressure)",
                    "Record FPS and Lua memory in baseline doc"
                )
        }
    }
}

Header "Finish"
Bullet "Update all three baseline docs"
Bullet "Run: ./scripts/check-profiling-readiness.ps1"
Bullet "Run: ./scripts/run-portfolio-preflight.ps1"

if ($RunGate) {
    Write-Host ""
    Write-Host "Running profiling readiness gate..." -ForegroundColor Yellow
    ./scripts/check-profiling-readiness.ps1
}

