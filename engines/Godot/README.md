# Signal Chase (Godot Flagship Vertical Slice)

## Overview

Signal Chase is a replayable 2D survival score-attack game built as the Godot flagship slice.
You collect targets while evading hunter drones and hazard fields, manage lives and combo chains,
and use stasis powerups to stabilize difficult phases.

## Quickstart

### Required Version

- Minimum supported: Godot 4.2.2
- Tested versions: Godot 4.2.2
- Other 4.x versions may work but are not currently verified in this repository.

### Run in Editor

1. Open Godot.
2. Import this folder: `engines/Godot`.
3. Run the project (main scene is `res://scenes/Main.tscn`).

### Run from CLI

From repository root:

```powershell
godot4 --path engines/Godot
```

Deterministic seeded run (for reproducible debugging):

```powershell
$env:SIGNAL_CHASE_SEED="424242"; godot4 --path engines/Godot
```

## Controls

- Move: Arrow keys or WASD
- Restart after round: Enter (`ui_accept`)
- Pause or resume: Esc (`ui_cancel`)

## Core Systems

- Progressive difficulty (levels scale by score)
- Dynamic pressure director that modulates threat intensity and powerup cadence
- Multiple threat types (chasing enemies + static hazards)
- Combo scoring with time window
- Life system with short invulnerability after damage
- Stasis powerup that slows enemy movement and grants bonus time
- Persistent best-score save in `user://signal_chase_save.json`
- Deterministic seed mode via `SIGNAL_CHASE_SEED`
- Run trace export to `user://signal_chase_latest_run.json`

## Vertical Slice Goals

- Deterministic run path and stable core loop
- Immediate feedback loop for scoring and restart behavior
- No external asset dependency (all visuals are primitive draw calls)
- Production-facing architecture documentation and release runbook

## Technical Highlights

- Explicit game state machine (`PLAYING`, `PAUSED`, `ROUND_OVER`)
- Pressure-aware enemy movement scaling for adaptive run pacing
- Difficulty controller that scales enemy/hazard pressure by score milestones
- Gameplay persistence for best-score continuity between sessions
- HUD telemetry for score/time/lives/level/combo/best state
- Replay telemetry events for input samples, hits, level-ups, and round-end state

## Performance Snapshot

See [PROFILING_BASELINE.md](PROFILING_BASELINE.md) for capture workflow and target thresholds.

## Acceptance Testing

Run and record pre-release checks in [ACCEPTANCE_TEST.md](ACCEPTANCE_TEST.md).

## Known Limitations

- No audio layer yet
- No exported binaries yet (editor/CLI run supported)
- Single gameplay mode currently; secondary modes pending

## Release Operations

- Packaging script: `engines/Godot/scripts/package-release.ps1`
- Release process: [RELEASE_RUNBOOK.md](RELEASE_RUNBOOK.md)
