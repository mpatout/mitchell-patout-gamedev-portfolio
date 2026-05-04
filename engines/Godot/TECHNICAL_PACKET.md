# Technical Packet

## Architecture

- `Main.tscn` is the runtime scene with lightweight HUD-only node structure.
- `main.gd` centralizes simulation through a finite game state model.
- Threat systems are represented as arrays of vectors for predictable update order.
- Save system writes best-score metadata to `user://signal_chase_save.json`.

## Key Decisions

- Start with primitive draw calls and no external assets to maximize iteration speed.
- Use one scene in Step 1 to reduce setup complexity while proving loop quality.
- Keep run-path deterministic (`res://scenes/Main.tscn`) to simplify reviewer onboarding.
- Scale complexity through data constants instead of scene sprawl for easier balancing.
- Separate collision checks by domain (target, enemy, hazard, powerup) for maintainability.

## Balance Notes

- Level progression uses score milestones (every 6 points) to keep difficulty readable.
- Enemy speed starts at 120 px/s with incremental scaling to maintain pressure.
- Combo window is tuned to 2.6s to reward deliberate route planning over passive play.
- Stasis powerup applies a temporary enemy slowdown for recovery without trivializing challenge.

## Debugging Notes

- Boundary clamping is centralized in `_clamp_player_to_viewport()`.
- Spawn safety loop prevents target placement too close to player start.
- Round state logic gates simulation while paused or after round over.
- Damage events are debounced with invulnerability timers to avoid multi-hit frame spikes.
- Pause/resume logic is centralized and testable through the acceptance checklist.

## Performance Notes

- Current scene remains draw-light (primitives only) with bounded entity counts.
- Enemy and hazard counts are level-capped to protect frame consistency.
- Profiling capture process is documented in `PROFILING_BASELINE.md`.

## Known Limitations

- Rendering/UI are intentionally minimal while mechanics stabilize.
- Audio and settings menu are deferred to next polish pass.
- Export presets still need to be configured inside Godot editor before binary releases.
- Save persistence defaults to score 0 if file I/O fails; gameplay remains functional.
