param(
    [Parameter(Mandatory = $true)]
    [string]$Repository,

    [Parameter(Mandatory = $false)]
    [string]$Token = $env:GITHUB_TOKEN
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Token)) {
    throw "GITHUB_TOKEN is required. Pass -Token or set env:GITHUB_TOKEN."
}

$headers = @{
    Authorization = "Bearer $Token"
    Accept = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $root

$releaseSpecs = @(
    @{
        Tag = "godot-signal-chase-v0.3.2"
        Name = "Godot Signal Chase v0.3.2"
        NotesPath = "docs/portfolio/release-notes/godot-signal-chase-v0.3.2.md"
        AssetPath = "engines/Godot/releases/godot-signal-chase-v0.3.2-source.zip"
    },
    @{
        Tag = "defold-pulse-grid-v0.1.0"
        Name = "Defold Pulse Grid v0.1.0"
        NotesPath = "docs/portfolio/release-notes/defold-pulse-grid-v0.1.0.md"
        AssetPath = "engines/defold/releases/defold-pulse-grid-v0.1.0-source.zip"
    },
    @{
        Tag = "solar2d-spark-catch-v0.2.0"
        Name = "Solar2D Spark Catch v0.2.0"
        NotesPath = "docs/portfolio/release-notes/solar2d-spark-catch-v0.2.0.md"
        AssetPath = "engines/solar2d/releases/solar2d-spark-catch-v0.2.0-source.zip"
    }
)

foreach ($spec in $releaseSpecs) {
    if (-not (Test-Path $spec.NotesPath)) {
        throw "Missing release notes file: $($spec.NotesPath)"
    }
    if (-not (Test-Path $spec.AssetPath)) {
        throw "Missing release asset file: $($spec.AssetPath)"
    }

    $bodyText = Get-Content $spec.NotesPath -Raw

    $releaseBody = @{
        tag_name = $spec.Tag
        name = $spec.Name
        body = $bodyText
        draft = $false
        prerelease = $false
        generate_release_notes = $false
    } | ConvertTo-Json

    Write-Host "Creating/updating release for tag $($spec.Tag)..." -ForegroundColor Cyan
    try {
        $release = Invoke-RestMethod -Method Post -Uri "https://api.github.com/repos/$Repository/releases" -Headers $headers -Body $releaseBody -ContentType "application/json"
    } catch {
        # If release already exists, fetch it and continue to asset upload.
        $release = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$Repository/releases/tags/$($spec.Tag)" -Headers $headers
    }

    $assetName = Split-Path $spec.AssetPath -Leaf
    $uploadUrl = ($release.upload_url -replace "\{\?name,label\}", "") + "?name=$assetName"

    Write-Host "Uploading asset $assetName..." -ForegroundColor Cyan
    Invoke-RestMethod -Method Post -Uri $uploadUrl -Headers @{
        Authorization = "Bearer $Token"
        Accept = "application/vnd.github+json"
        "Content-Type" = "application/zip"
    } -InFile $spec.AssetPath
}

Write-Host "Release publishing completed." -ForegroundColor Green
