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

## Debugging Notes

- Boundary clamping is centralized in `_clamp_player_to_viewport()`.
- Spawn safety loop prevents target placement too close to player start.
- Round state logic gates simulation while paused or after round over.
- Damage events are debounced with invulnerability timers to avoid multi-hit frame spikes.

## Performance Notes

- Current scene remains draw-light (primitives only) with bounded entity counts.
- Enemy and hazard counts are level-capped to protect frame consistency.
- Profiling capture process is documented in `PROFILING_BASELINE.md`.

## Known Limitations

- Rendering/UI are intentionally minimal while mechanics stabilize.
- Audio and settings menu are deferred to next polish pass.
- Export presets still need to be configured inside Godot editor before binary releases.
