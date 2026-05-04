param(
    [Parameter(Mandatory = $true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptDir "..")
$repoRoot = Resolve-Path (Join-Path $projectRoot "..\..")

Set-Location $repoRoot

$outputDir = Join-Path $projectRoot "releases"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$artifactName = "godot-signal-chase-v$Version-source.zip"
$artifactPath = Join-Path $outputDir $artifactName
if (Test-Path $artifactPath) {
    Remove-Item $artifactPath -Force
}

$stageDir = Join-Path $outputDir "stage"
if (Test-Path $stageDir) {
    Remove-Item $stageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $stageDir | Out-Null

$filesToCopy = @(
    "engines/Godot/project.godot",
    "engines/Godot/README.md",
    "engines/Godot/PROJECT_SCOPE.md",
    "engines/Godot/TECHNICAL_PACKET.md",
    "engines/Godot/PROFILING_BASELINE.md",
    "engines/Godot/RELEASE_RUNBOOK.md",
    "engines/Godot/CHANGELOG.md",
    "engines/Godot/ASSET_PROVENANCE.md",
    "engines/Godot/scenes/Main.tscn",
    "engines/Godot/scripts/main.gd"
)

foreach ($path in $filesToCopy) {
    $source = Join-Path $repoRoot $path
    if (-not (Test-Path $source)) {
        throw "Missing required release file: $path"
    }

    $dest = Join-Path $stageDir $path
    $destParent = Split-Path -Parent $dest
    if (-not (Test-Path $destParent)) {
        New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }
    Copy-Item -Path $source -Destination $dest -Force
}

Compress-Archive -Path (Join-Path $stageDir "*") -DestinationPath $artifactPath
Remove-Item $stageDir -Recurse -Force
Write-Host "Created $artifactPath" -ForegroundColor Green
