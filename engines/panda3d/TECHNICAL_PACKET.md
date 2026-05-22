# TECHNICAL_PACKET - Panda3D: Lane Drift

## Architecture

```
engines/panda3d/
|- main.py                      Game app, loop, spawn/collision/state logic
|- requirements.txt             Runtime dependency pin (Panda3D)
|- runtime/
|  \- lane_drift_latest_run.json  Deterministic run trace output
|- scripts/
|  |- package-release.ps1       Source artifact packaging
|  \- quality-gate.ps1          Project validity checks + CI preview package
\- *.md                         Scope, acceptance, profiling, and release docs
```

Single-file gameplay logic is intentional for this vertical slice: reviewer
speed and deterministic debugging are prioritized over subsystem decomposition.

## Key Decisions

| Decision | Choice | Rationale |
|---|---|---|
| World model | 5 fixed lanes | Easy-to-test input and deterministic collision checks |
| Update loop | Panda3D task manager (`taskMgr.add`) | Idiomatic real-time loop in Panda3D |
| Collision model | Lane match + distance threshold | Fast and stable without physics setup |
| Persistence | Local JSON save file | Cross-machine portability for portfolio runs |
| Determinism | `PANDA3D_SEED` env var | Reproducible bug repro / score regression checks |
| Trace model | Event list JSON | Lightweight debugging evidence artifact |

## Debugging Notes

- If controls do not respond, verify key bindings in `main.py` and window focus.
- If trace file is missing, confirm write permissions to `engines/panda3d/runtime/`.
- For deterministic replay checks, run two sessions with the same `PANDA3D_SEED`
	and compare event sequences.

## Performance Notes

- Active obstacle count is bounded by despawn logic.
- Per-frame update cost is linear in active obstacles and remains small for this scope.
- No post-processing or heavy shader usage in current baseline.

## Known Limitations

- No physics-engine integration.
- No pause menu/state stack yet.
- No cross-session leaderboard sync; local-only best score persistence.
