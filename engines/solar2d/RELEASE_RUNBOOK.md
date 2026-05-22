# RELEASE_RUNBOOK - Solar2D: Spark Catch

## Versioning

Use semantic versioning tags: `vMAJOR.MINOR.PATCH`.

## Pre-Release Checklist

1. Complete `ACCEPTANCE_TEST.md`.
2. Update `CHANGELOG.md` with release date and changes.
3. Confirm `ASSET_PROVENANCE.md` is current.
4. Ensure `PROFILING_BASELINE.md` includes latest capture notes.

## Package Artifact

From repository root:

```powershell
./engines/solar2d/scripts/package-release.ps1 -Version "0.2.0"
```

Expected output:
- `engines/solar2d/releases/solar2d-spark-catch-v0.2.0-source.zip`

## GitHub Release Notes Template

- Scope summary: Spark Catch vertical slice features.
- Technical updates: systems, architecture, tooling changes.
- Performance notes: latest FPS and memory observations.
- Known limitations: unresolved items and workarounds.

## Post-Release Checks

1. Tag is pushed and visible.
2. Release artifact downloads successfully.
3. Artifact opens and includes required docs + source files.
