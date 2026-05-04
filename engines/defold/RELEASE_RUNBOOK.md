# RELEASE_RUNBOOK \u2014 Defold: Pulse Grid

## Versioning Policy

Follow SemVer (`MAJOR.MINOR.PATCH`). Update `game.project` \u2192 `version` field
and `CHANGELOG.md` before tagging.

## Pre-Flight Checks

```powershell
# From repo root
./scripts/validate-structure.ps1
./engines/defold/scripts/quality-gate.ps1
```

Both must exit 0 before proceeding.

## Packaging Steps

```powershell
./engines/defold/scripts/package-release.ps1 -Version 0.1.0
```

Artifact written to: `engines/defold/releases/defold-pulse-grid-v0.1.0-source.zip`

Verify output:
1. Unzip and confirm all source files are present.
2. Re-open the project in Defold Editor from the unzipped folder and run the
   acceptance test checklist in `ACCEPTANCE_TEST.md`.

## Tagging & GitHub Release

```powershell
git tag defold-v0.1.0
git push origin defold-v0.1.0
```

On GitHub:
1. **Releases \u2192 Draft a new release** \u2192 tag `defold-v0.1.0`.
2. Title: `Defold: Pulse Grid v0.1.0`.
3. Copy the `[0.1.0]` section from `CHANGELOG.md` as release notes.
4. Attach `defold-pulse-grid-v0.1.0-source.zip`.
5. Publish.

## Post-Release

- Update `docs/portfolio/IMPLEMENTATION_STATUS.md` \u2192 mark Defold row published.
- Update `docs/portfolio/COMPETENCY_MATRIX.md` \u2192 add evidence links for Defold row.
