# Changelog

## [0.2.1] - 2026-05-22

### Added

- Deterministic run support via `SPARK_CATCH_SEED`.
- Run trace export to `spark_catch_latest_run.json`.
- Telemetry event logging for catches, misses, level-ups, pause events, and round end.
- Trace summary helper script `scripts/summarize-trace.ps1`.

### Changed

- README, technical packet, and acceptance tests updated with deterministic debugging workflow.

## [0.2.0] - 2026-05-22

### Added

- Runnable Solar2D game baseline in `main.lua`.
- Delta-time update loop with title, playing, paused, and round-over states.
- Spawn budget and level scaling system.
- Three drop types (spark, shard, overcharge) with distinct risk profiles.
- Overcharge risk-reward window with temporary score multiplier.
- Best-score persistence to local JSON save file.
- Release operations docs (`RELEASE_RUNBOOK.md`) and acceptance checklist.
- Profiling baseline template and Solar2D packaging/quality scripts.

## [0.1.0] - 2026-05-04

### Added

- Initial project placeholder structure.
