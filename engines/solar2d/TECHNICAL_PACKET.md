# TECHNICAL_PACKET — Solar2D: Spark Catch

## Architecture

```
engines/solar2d/
├── config.lua                     Simulator window and scale config
├── main.lua                       Game state, update loop, spawn logic
├── README.md                      Quickstart and controls
├── PROJECT_SCOPE.md               Scope boundaries and exit criteria
├── PROFILING_BASELINE.md          Capture instructions and metrics table
├── ACCEPTANCE_TEST.md             Functional regression checklist
├── RELEASE_RUNBOOK.md             Release process and package conventions
└── scripts/
		├── quality-gate.ps1           File and script validation
		└── package-release.ps1        Source artifact packager
```

### Runtime Flow

1. `main.lua` initializes HUD, input catcher, and save data.
2. Tapping the prompt transitions state from `title` to `playing`.
3. `enterFrame` advances timers, spawn budget, level progression, and
	 per-object movement.
4. Catch/miss handlers mutate score, combo, lives, and risk windows.
5. Round end writes best score and exposes restart prompt.

## Key Decisions

| Decision | Choice | Rationale |
| --- | --- | --- |
| Update loop | Delta-time `enterFrame` | Stable pacing across desktop/mobile refresh rates |
| Object model | Table-backed active list | Lightweight and easy to inspect for debugging |
| Input model | Drag catcher movement | Mobile-first control with low cognitive load |
| Risk mechanic | Overcharge window | Adds strategic depth without needing many assets |
| Persistence | JSON save file in documents dir | Solar2D-native and cross-platform |
| Reproducibility | Seeded RNG + trace export | Deterministic debugging and run analysis |

## Deterministic Replay Instrumentation

- `SPARK_CATCH_SEED` locks RNG seed for deterministic test runs.
- When seed is not specified, the game derives a rotating seed per round.
- Run traces are written to `spark_catch_latest_run.json` in DocumentsDirectory.
- Trace events include round start/end, catches, misses, level-ups, pause transitions,
  and overcharge activity.

## Debugging Notes

- If touches do not move catcher, verify drag listener is attached to the catcher
	display object and not blocked by overlay text.
- If rounds never start, confirm title prompt tap handler invokes
	`start_round()` and game state transitions from `title`.
- If score desync appears after restart, validate `reset_round_state()` clears
	object table and timers before first spawn.
- If performance degrades after long runs, ensure off-screen objects are removed
	and `display.remove` is called for each despawn path.
- For reproducible bugs, set `SPARK_CATCH_SEED`, run a full round, and summarize
  telemetry using `engines/solar2d/scripts/summarize-trace.ps1`.

## Performance Notes

- Typical active object count stays below 25 in high-pressure windows.
- All visuals are primitive circles/rectangles, avoiding texture overhead.
- Spawn-rate acceleration is bounded by a minimum interval, preventing runaway
	object creation.
- Trace event volume is capped to avoid oversized run files.

## Known Limitations

- No audio feedback yet.
- No object pooling; objects are created/removed directly for simplicity.
- Native mobile build/export must be done manually in Solar2D tooling.
- Trace payload is event-sampled and not frame-accurate replay state.
