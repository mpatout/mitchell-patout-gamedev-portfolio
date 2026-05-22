# RELEASE_RUNBOOK - Panda3D: Lane Drift

## Versioning Policy

Follow SemVer (`MAJOR.MINOR.PATCH`). Update `CHANGELOG.md` before tagging.

## Pre-Flight Checks

```powershell
# From repo root
./scripts/validate-structure.ps1
./engines/panda3d/scripts/quality-gate.ps1
```

Both must exit 0 before proceeding.

## Packaging Steps

```powershell
./engines/panda3d/scripts/package-release.ps1 -Version 0.1.0
```

Artifact written to: `engines/panda3d/releases/panda3d-lane-drift-v0.1.0-source.zip`

## Tagging & GitHub Release

```powershell
git tag panda3d-lane-drift-v0.1.0
git push origin panda3d-lane-drift-v0.1.0
```

On GitHub:
1. Releases -> Draft a new release -> tag `panda3d-lane-drift-v0.1.0`.
2. Title: `Panda3D: Lane Drift v0.1.0`.
3. Copy the `[0.1.0]` section from `engines/panda3d/CHANGELOG.md`.
4. Attach `panda3d-lane-drift-v0.1.0-source.zip`.
5. Publish.
