param(
    [Parameter(Mandatory = $false)]
    [string]$TracePath = "$env:APPDATA\Godot\app_userdata\Godot\signal_chase_latest_run.json",

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "docs/portfolio/evidence/godot_trace_summary.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $repoRoot

if (-not (Test-Path $TracePath)) {
    throw "Trace file not found: $TracePath"
}

$trace = Get-Content $TracePath -Raw | ConvertFrom-Json
$events = @($trace.events)

$targetCount = ($events | Where-Object { $_.type -eq "target_collected" }).Count
$hitCount = ($events | Where-Object { $_.type -eq "player_hit" }).Count
$levelUps = ($events | Where-Object { $_.type -eq "level_up" }).Count
$powerupCollects = ($events | Where-Object { $_.type -eq "powerup_collected" }).Count

$maxPressure = 0.0
foreach ($e in $events) {
    if ($null -ne $e.pressure) {
        $p = [double]$e.pressure
        if ($p -gt $maxPressure) { $maxPressure = $p }
    }
}

$summary = @"
# Godot Trace Summary

## Run Metadata

- Seed: $($trace.seed)
- Seed Locked: $($trace.seed_locked)
- Duration Seconds: $($trace.duration_seconds)
- Final Score: $($trace.score)
- Best Score: $($trace.best_score)
- Final Level: $($trace.level)
- End Reason: $($trace.end_reason)

## Event Totals

- Targets Collected: $targetCount
- Player Hits: $hitCount
- Level Ups: $levelUps
- Powerups Collected: $powerupCollects
- Max Pressure Observed: $maxPressure

## Notes

This summary is generated from user://signal_chase_latest_run.json and can be
attached to release notes or debugging case studies.
"@

$outputDir = Split-Path $OutputPath -Parent
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

Set-Content -Path $OutputPath -Value $summary -Encoding UTF8
Write-Host "Wrote trace summary: $OutputPath" -ForegroundColor Green
