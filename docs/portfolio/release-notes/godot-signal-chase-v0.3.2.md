# Godot Signal Chase v0.3.2

## Scope Summary

Production-hardening update that adds reproducible debugging support and adaptive gameplay pressure.

## Key Technical Updates

- Added deterministic run mode via SIGNAL_CHASE_SEED.
- Added run trace export to user://signal_chase_latest_run.json.
- Added telemetry event stream for target captures, hits, level shifts, powerups, and round end.
- Added dynamic pressure director to modulate enemy speed and powerup cadence.
- Expanded acceptance coverage for deterministic and adaptive behavior checks.

## Performance Notes

- Entity counts remain capped by level and are still draw-light (primitive rendering only).
- Runtime profiling capture is complete; see docs/portfolio/PROFILING_EVIDENCE_INDEX.md.

## Known Issues

- Audio is not implemented.
- Export presets for native binaries are not yet configured.
- Replay trace stores sampled event telemetry, not per-frame full-state snapshots.
