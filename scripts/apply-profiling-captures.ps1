param(
    [Parameter(Mandatory = $false)]
    [string]$DataFile = "docs/portfolio/evidence/profiling/capture-data.json",
    [switch]$ValidateScreenshots
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

if (-not (Test-Path $DataFile)) {
    throw "Data file not found: $DataFile"
}

$data = Get-Content $DataFile -Raw | ConvertFrom-Json

function RequireValue([object]$value, [string]$name) {
    if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) {
        throw "Missing required value: $name"
    }
}

# Required fields
RequireValue $data.meta.date "meta.date"
RequireValue $data.meta.deviceOs "meta.deviceOs"
RequireValue $data.godot.version "godot.version"
RequireValue $data.godot.low.fpsRange "godot.low.fpsRange"
RequireValue $data.godot.low.largestSpike "godot.low.largestSpike"
RequireValue $data.godot.low.notes "godot.low.notes"
RequireValue $data.godot.high.fpsRange "godot.high.fpsRange"
RequireValue $data.godot.high.largestSpike "godot.high.largestSpike"
RequireValue $data.godot.high.notes "godot.high.notes"
RequireValue $data.defold.low.frameTimeMs "defold.low.frameTimeMs"
RequireValue $data.defold.low.scriptSelfTimeMs "defold.low.scriptSelfTimeMs"
RequireValue $data.defold.low.notes "defold.low.notes"
RequireValue $data.defold.high.frameTimeMs "defold.high.frameTimeMs"
RequireValue $data.defold.high.scriptSelfTimeMs "defold.high.scriptSelfTimeMs"
RequireValue $data.defold.high.notes "defold.high.notes"
RequireValue $data.solar2d.low.fps "solar2d.low.fps"
RequireValue $data.solar2d.low.luaMemoryKb "solar2d.low.luaMemoryKb"
RequireValue $data.solar2d.low.activeObjects "solar2d.low.activeObjects"
RequireValue $data.solar2d.low.notes "solar2d.low.notes"
RequireValue $data.solar2d.high.fps "solar2d.high.fps"
RequireValue $data.solar2d.high.luaMemoryKb "solar2d.high.luaMemoryKb"
RequireValue $data.solar2d.high.activeObjects "solar2d.high.activeObjects"
RequireValue $data.solar2d.high.notes "solar2d.high.notes"

if ($ValidateScreenshots) {
    $requiredScreens = @(
        "docs/portfolio/evidence/profiling/godot/low-pressure.png",
        "docs/portfolio/evidence/profiling/godot/high-pressure.png",
        "docs/portfolio/evidence/profiling/defold/low-pressure.png",
        "docs/portfolio/evidence/profiling/defold/high-pressure.png",
        "docs/portfolio/evidence/profiling/solar2d/low-pressure.png",
        "docs/portfolio/evidence/profiling/solar2d/high-pressure.png"
    )

    foreach ($path in $requiredScreens) {
        if (-not (Test-Path $path)) {
            throw "Missing screenshot: $path"
        }
    }
}

$godotPath = "engines/Godot/PROFILING_BASELINE.md"
$godotText = Get-Content $godotPath -Raw
$godotLow = "| $($data.meta.date) | Level 1 low pressure | $($data.meta.deviceOs) | $($data.godot.version) | $($data.godot.low.fpsRange) | $($data.godot.low.largestSpike) | $($data.godot.low.notes) |"
$godotHigh = "| $($data.meta.date) | Level 5+ high pressure | $($data.meta.deviceOs) | $($data.godot.version) | $($data.godot.high.fpsRange) | $($data.godot.high.largestSpike) | $($data.godot.high.notes) |"
$oldGodotLow = "| Pending | Level 1 low pressure | Pending | Pending | Pending | Pending | Capture not yet recorded |"
$oldGodotHigh = "| Pending | Level 5+ high pressure | Pending | Pending | Pending | Pending | Capture not yet recorded |"
if (-not $godotText.Contains($oldGodotLow)) { throw "Expected Godot low-pressure Pending row not found" }
if (-not $godotText.Contains($oldGodotHigh)) { throw "Expected Godot high-pressure Pending row not found" }
$godotText = $godotText.Replace($oldGodotLow, $godotLow)
$godotText = $godotText.Replace($oldGodotHigh, $godotHigh)
$godotText = $godotText.Replace("## First Capture Status`n`nPending local Godot editor run.", "## First Capture Status`n`nCaptured and recorded. See Capture Log and screenshot evidence paths.")
Set-Content -Path $godotPath -Value $godotText -Encoding UTF8

$defoldPath = "engines/defold/PROFILING_BASELINE.md"
$defoldText = Get-Content $defoldPath -Raw
$defoldLow = "| Low pressure  | Level 1, 1 active cell  | $($data.defold.low.frameTimeMs) | $($data.defold.low.scriptSelfTimeMs) | 25 | $($data.defold.low.notes) |"
$defoldHigh = "| High pressure | Level 6+, 3-4 active cells | $($data.defold.high.frameTimeMs) | $($data.defold.high.scriptSelfTimeMs) | 25 | $($data.defold.high.notes) |"
$oldDefoldLow = "| Low pressure  | Level 1, 1 active cell  | Pending | Pending | 25 | Capture manually |"
$oldDefoldHigh = "| High pressure | Level 6+, 3-4 active cells | Pending | Pending | 25 | Capture manually |"
if (-not $defoldText.Contains($oldDefoldLow)) { throw "Expected Defold low-pressure Pending row not found" }
if (-not $defoldText.Contains($oldDefoldHigh)) { throw "Expected Defold high-pressure Pending row not found" }
$defoldText = $defoldText.Replace($oldDefoldLow, $defoldLow)
$defoldText = $defoldText.Replace($oldDefoldHigh, $defoldHigh)
$defoldText = $defoldText.Replace("> **Note:** Defold Editor must be installed locally to run the profiler.`n> Fill in the Pending values before submission.", "> **Note:** Defold captures recorded and baseline updated from capture data file.")
Set-Content -Path $defoldPath -Value $defoldText -Encoding UTF8

$solarPath = "engines/solar2d/PROFILING_BASELINE.md"
$solarText = Get-Content $solarPath -Raw
$solarLow = "| Low pressure | Level 1, no overcharge | $($data.solar2d.low.fps) | $($data.solar2d.low.luaMemoryKb) | $($data.solar2d.low.activeObjects) | $($data.solar2d.low.notes) |"
$solarHigh = "| High pressure | Level 6+, overcharge active | $($data.solar2d.high.fps) | $($data.solar2d.high.luaMemoryKb) | $($data.solar2d.high.activeObjects) | $($data.solar2d.high.notes) |"
$oldSolarLow = "| Low pressure | Level 1, no overcharge | Pending | Pending | Pending | Capture manually |"
$oldSolarHigh = "| High pressure | Level 6+, overcharge active | Pending | Pending | Pending | Capture manually |"
if (-not $solarText.Contains($oldSolarLow)) { throw "Expected Solar2D low-pressure Pending row not found" }
if (-not $solarText.Contains($oldSolarHigh)) { throw "Expected Solar2D high-pressure Pending row not found" }
$solarText = $solarText.Replace($oldSolarLow, $solarLow)
$solarText = $solarText.Replace($oldSolarHigh, $solarHigh)
Set-Content -Path $solarPath -Value $solarText -Encoding UTF8

Write-Host "Profiling baseline docs updated from: $DataFile" -ForegroundColor Green
