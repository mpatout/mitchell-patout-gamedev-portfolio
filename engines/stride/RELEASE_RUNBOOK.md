# RELEASE_RUNBOOK - Stride: Lane Surge

## Versioning Policy

Follow SemVer (`MAJOR.MINOR.PATCH`). Update `CHANGELOG.md` before tagging.

## Pre-Flight Checks

```powershell
# From repo root
./scripts/validate-structure.ps1
./engines/stride/scripts/quality-gate.ps1
```

Both must exit 0 before proceeding.

## Packaging Steps

```powershell
./engines/stride/scripts/package-release.ps1 -Version 0.1.0
```

Artifact written to: `engines/stride/releases/stride-lane-surge-v0.1.0-source.zip`

## Tagging & GitHub Release

```powershell
git tag stride-lane-surge-v0.1.0
git push origin stride-lane-surge-v0.1.0
```

On GitHub:
1. Releases -> Draft a new release -> tag `stride-lane-surge-v0.1.0`.
2. Title: `Stride: Lane Surge v0.1.0`.
3. Copy the `[0.1.0]` section from `engines/stride/CHANGELOG.md`.
4. Attach `stride-lane-surge-v0.1.0-source.zip`.
5. Publish.
