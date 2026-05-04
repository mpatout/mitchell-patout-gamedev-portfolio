# Release Runbook

Use this runbook to produce a reproducible Godot release package.

## Versioning

- Keep `CHANGELOG.md` updated before packaging.
- Use semantic version tags for each release.

## Packaging Steps

1. Confirm project runs from editor and CLI.
2. Ensure required docs are current:
- `README.md`
- `PROJECT_SCOPE.md`
- `TECHNICAL_PACKET.md`
- `PROFILING_BASELINE.md`
- `ASSET_PROVENANCE.md`
3. Run packaging script:

```powershell
./engines/godot/scripts/package-release.ps1 -Version 0.3.0
```

4. Verify output in `engines/godot/releases/`.
5. Publish artifact to GitHub Releases with matching tag.

## Preflight Checks

- Run repository structure check:

```powershell
./scripts/validate-structure.ps1
```

- Run Godot quality gate:

```powershell
./engines/godot/scripts/quality-gate.ps1
```

## GitHub Publish Flow

1. Commit release changes.
2. Create and push tag:

```powershell
git tag v0.3.0
git push origin v0.3.0
```

3. In GitHub Releases, create a release from tag `v0.3.0`.
4. Upload `godot-signal-chase-v0.3.0-source.zip` as release asset.
5. Copy summary notes from `CHANGELOG.md`.

## Artifact Naming

- Source package: `godot-signal-chase-v<version>-source.zip`

## Notes

Editor export presets for platform binaries are configured in Godot editor and can be added once export targets are finalized.
