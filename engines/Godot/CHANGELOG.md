# Changelog

## [0.3.2] - 2026-05-22

### Added

- Deterministic run support through `SIGNAL_CHASE_SEED` environment variable.
- Replay trace export to `user://signal_chase_latest_run.json` with sampled input and gameplay events.
- Telemetry event logging for target captures, hits, level-ups, powerups, and round end.

### Changed

- Updated technical packet and README with deterministic debugging workflow.
- Expanded acceptance tests with seeded replay verification steps.

## [0.3.1] - 2026-05-04

### Added

- Acceptance test suite for pre-release validation.
- Godot quality gate checks for project config and scene/script linkage.

### Changed

- Locked tested Godot feature version to 4.2.2.
- Updated README with tested-version policy and acceptance-test reference.
- Updated competency matrix with concrete Godot evidence mapping.

## [0.3.0] - 2026-05-04

### Added

- Threat systems: pursuing enemies and static hazard fields.
- Life system, pause/resume flow, and round-state management.
- Combo scoring window with level-based difficulty scaling.
- Stasis powerup behavior and persistent best-score save file.
- Profiling baseline document and release runbook.
- Packaging script for source release artifact creation.

## [0.2.0] - 2026-05-04

### Added

- Runnable Godot project configuration (`project.godot`).
- Main gameplay scene and script with score-attack loop.
- HUD, timer, restart behavior, and target collection mechanics.
- Concrete quickstart, scope, and technical packet documentation.

## [0.1.0] - 2026-05-04

### Added

- Initial project placeholder structure.
