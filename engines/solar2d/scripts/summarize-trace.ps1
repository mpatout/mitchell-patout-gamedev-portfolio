param(
    [Parameter(Mandatory = $false)]
    [string]$TracePath,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "docs/portfolio/evidence/solar2d_trace_summary.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $repoRoot

if ([string]::IsNullOrWhiteSpace($TracePath)) {
    $candidates = @(
        "$env:USERPROFILE\AppData\Roaming\Corona Labs\Simulator\Documents\spark_catch_latest_run.json",
        "$env:USERPROFILE\Documents\Corona Labs\Simulator\Documents\spark_catch_latest_run.json",
        "engines/solar2d/spark_catch_latest_run.json"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            $TracePath = $candidate
            break
        }
    }
}

if ([string]::IsNullOrWhiteSpace($TracePath) -or -not (Test-Path $TracePath)) {
    throw "Trace file not found. Pass -TracePath with a valid spark_catch_latest_run.json file."
}

$trace = Get-Content $TracePath -Raw | ConvertFrom-Json
$events = @($trace.events)

$sparkCatches = ($events | Where-Object { $_.type -eq "spark_catch" }).Count
$sparkMisses = ($events | Where-Object { $_.type -eq "spark_missed" }).Count
$shardCatches = ($events | Where-Object { $_.type -eq "shard_catch" }).Count
$levelUps = ($events | Where-Object { $_.type -eq "level_up" }).Count
$overchargeCatches = ($events | Where-Object { $_.type -eq "overcharge_catch" }).Count

$summary = @"
# Solar2D Trace Summary

## Run Metadata

- Seed: $($trace.seed)
- Seed Locked: $($trace.seedLocked)
- Duration Seconds: $($trace.durationSeconds)
- Final Score: $($trace.score)
- Best Score: $($trace.bestScore)
- Final Level: $($trace.level)
- End Reason: $($trace.endReason)

## Event Totals

- Spark Catches: $sparkCatches
- Spark Misses: $sparkMisses
- Shard Catches: $shardCatches
- Level Ups: $levelUps
- Overcharge Catches: $overchargeCatches

## Notes

This summary is generated from spark_catch_latest_run.json and is intended for
release notes or debugging evidence.
"@

$outputDir = Split-Path $OutputPath -Parent
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

Set-Content -Path $OutputPath -Value $summary -Encoding UTF8
Write-Host "Wrote trace summary: $OutputPath" -ForegroundColor Green
