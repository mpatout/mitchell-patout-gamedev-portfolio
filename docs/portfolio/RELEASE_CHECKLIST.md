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
