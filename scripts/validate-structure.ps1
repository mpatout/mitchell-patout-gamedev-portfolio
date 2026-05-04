param()

$ErrorActionPreference = "Stop"

$requiredRoot = @(
    "README.md",
    "docs/portfolio/ROLE_FIT_RUBRIC.md",
    "docs/portfolio/COMPETENCY_MATRIX.md",
    "docs/portfolio/RELEASE_CHECKLIST.md",
    "docs/standards/README_TEMPLATE.md",
    "docs/standards/ASSET_PROVENANCE_POLICY.md",
    "docs/standards/CHANGELOG_POLICY.md",
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/ISSUE_TEMPLATE/bug_report.yml"
)

$engines = @("godot", "defold", "solar2d", "panda3d", "stride")
$requiredEngineFiles = @(
    "README.md",
    "PROJECT_SCOPE.md",
    "TECHNICAL_PACKET.md",
    "CHANGELOG.md",
    "ASSET_PROVENANCE.md"
)

$missing = New-Object System.Collections.Generic.List[string]

foreach ($path in $requiredRoot) {
    if (-not (Test-Path $path)) {
        $missing.Add($path)
    }
}

foreach ($engine in $engines) {
    $engineDir = "engines/$engine"
    if (-not (Test-Path $engineDir)) {
        $missing.Add($engineDir)
        continue
    }

    foreach ($file in $requiredEngineFiles) {
        $full = "$engineDir/$file"
        if (-not (Test-Path $full)) {
            $missing.Add($full)
        }
    }
}

if ($missing.Count -gt 0) {
    Write-Host "Missing required structure:" -ForegroundColor Red
    $missing | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "Structure validation passed." -ForegroundColor Green
