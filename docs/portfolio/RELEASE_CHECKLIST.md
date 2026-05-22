# Release Checklist

Use this checklist before creating a GitHub Release for any engine project.

## Pre-Release

- [ ] Project quickstart tested on clean checkout
- [ ] Required project artifacts present
- [ ] Critical bugs resolved or documented as known limitations
- [ ] Changelog updated with release version and date
- [ ] Asset provenance updated for all new assets

## Build Packaging

- [ ] Artifact naming uses: `<engine>-<project>-v<version>-<platform>.zip`
- [ ] Build timestamp and commit SHA recorded in release notes
- [ ] Platform-specific run notes included if needed

## Release Notes

- [ ] Summary of gameplay scope
- [ ] Key technical updates
- [ ] Performance notes
- [ ] Known issues and workaround notes

## Post-Release

- [ ] Tag pushed and verified
- [ ] Release downloadable and integrity checked
- [ ] Follow-up issues created for deferred fixes

## Repository Helpers

- Release notes templates live under `docs/portfolio/release-notes/`.
- Artifacts can be generated with each engine package script.
- GitHub releases can be published through `scripts/publish-github-releases.ps1`
	using a `GITHUB_TOKEN` with repo permissions.
- Profiling evidence requirements are tracked in `docs/portfolio/PROFILING_EVIDENCE_INDEX.md`.
- Profile gate can be checked with `scripts/check-profiling-readiness.ps1`.
