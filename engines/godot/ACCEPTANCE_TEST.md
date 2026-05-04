# Acceptance Test Suite

Use this checklist before creating any submission release.

## Environment

- OS: ____________________
- CPU/GPU: ____________________
- Godot Version: ____________________
- Test Date: ____________________

## Gameplay Loop Tests

- [ ] Start a new round and collect at least 3 targets.
- [ ] Reach level 5 or higher without script/runtime errors.
- [ ] Trigger stasis powerup and verify enemy slowdown is visible.
- [ ] Take 3 hits and verify round-over state appears.
- [ ] Press Enter at round-over and verify clean restart.

## State And Input Tests

- [ ] Pause and resume 5 times in one round; timer remains consistent.
- [ ] Pause immediately after taking damage; invulnerability still expires correctly.
- [ ] Validate both Arrow keys and WASD movement, including diagonal normalization.

## Persistence Tests

- [ ] Set a new best score.
- [ ] Restart game and verify best score persists.
- [ ] If persistence fails, gameplay still continues without crash.

## Stability Tests

- [ ] Run 10 consecutive rounds without crash.
- [ ] Run one full round with frequent movement and pause toggling.
- [ ] Verify no out-of-bounds player position after extended play.

## Submission Exit Criteria

- [ ] All tests above pass.
- [ ] `PROFILING_BASELINE.md` contains measured data.
- [ ] Release artifact generated via `package-release.ps1`.
- [ ] Changelog and release notes are synchronized.
