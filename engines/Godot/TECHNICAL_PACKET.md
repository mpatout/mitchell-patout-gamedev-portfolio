# Technical Packet

## Architecture

- `Main.tscn` is the runtime scene with lightweight HUD-only node structure.
- `main.gd` centralizes simulation through a finite game state model.
- Threat systems are represented as arrays of vectors for predictable update order.
- Save system writes best-score metadata to `user://signal_chase_save.json`.
- Replay trace writer exports per-run telemetry to `user://signal_chase_latest_run.json`.

## Key Decisions

- Start with primitive draw calls and no external assets to maximize iteration speed.
- Use one scene in Step 1 to reduce setup complexity while proving loop quality.
- Keep run-path deterministic (`res://scenes/Main.tscn`) to simplify reviewer onboarding.
- Scale complexity through data constants instead of scene sprawl for easier balancing.
- Separate collision checks by domain (target, enemy, hazard, powerup) for maintainability.
- Support deterministic seeded runs with `SIGNAL_CHASE_SEED` for reproducible bug reports.
- Capture lightweight telemetry events to create replay-ready run traces.
- Use a dynamic pressure director to adapt enemy speed and powerup interval to player performance.

## Deterministic Replay Instrumentation

- `SIGNAL_CHASE_SEED` environment variable locks RNG seed for deterministic runs.
- Default mode rotates seeds per run (`seed_base + run_index * 7919`) to preserve
	gameplay variety outside debugging sessions.
- Input vectors are sampled every 0.2s and appended to the run trace.
- Major events are logged with timestamp and state payload:
	- target collection
	- powerup spawn/collection
	- player hits
	- level transitions
	- round end
- Trace payload includes seed, score, duration, level, and full event list.

## Balance Notes

- Level progression uses score milestones (every 6 points) to keep difficulty readable.
- Enemy speed starts at 120 px/s with incremental scaling to maintain pressure.
- Combo window is tuned to 2.6s to reward deliberate route planning over passive play.
- Stasis powerup applies a temporary enemy slowdown for recovery without trivializing challenge.
- Pressure director increases intensity when chains are sustained, then decays pressure
	over time or after player damage to stabilize pacing.

## Debugging Notes

- Boundary clamping is centralized in `_clamp_player_to_viewport()`.
- Spawn safety loop prevents target placement too close to player start.
- Round state logic gates simulation while paused or after round over.
- Damage events are debounced with invulnerability timers to avoid multi-hit frame spikes.
- Pause/resume logic is centralized and testable through the acceptance checklist.
- Deterministic mode allows reproducing threat and target spawn sequences exactly.

## Performance Notes

- Current scene remains draw-light (primitives only) with bounded entity counts.
- Enemy and hazard counts are level-capped to protect frame consistency.
- Profiling capture process is documented in `PROFILING_BASELINE.md`.
- Replay event count is bounded (`MAX_TRACE_EVENTS`) to avoid runaway trace files.
- Pressure-adjusted powerup interval is bounded (8.5s to 16.5s) to avoid extreme variance.

## Known Limitations

- Rendering/UI are intentionally minimal while mechanics stabilize.
- Audio and settings menu are deferred to next polish pass.
- Export presets still need to be configured inside Godot editor before binary releases.
- Save persistence defaults to score 0 if file I/O fails; gameplay remains functional.
- Replay traces currently store sampled inputs/events, not full per-frame snapshots.
