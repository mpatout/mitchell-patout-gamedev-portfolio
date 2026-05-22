# Lane Drift - Panda3D

## Overview

Lane Drift is a Panda3D vertical slice focused on core loop reliability.
You steer across fixed lanes while obstacles approach from ahead. Survive as
long as possible as spawn cadence increases over time.

Showcases: Panda3D scene graph usage, frame-task game loop, deterministic seed
control, JSON run tracing, and release/quality workflow discipline.

## Quickstart

1. Create/activate a Python environment (3.10+ recommended).
2. Install dependencies:

```powershell
pip install -r engines/panda3d/requirements.txt
```

3. Run:

```powershell
python engines/panda3d/main.py
```

4. Optional deterministic seed:

```powershell
$env:PANDA3D_SEED="20260522"
python engines/panda3d/main.py
```

## Controls

| Key | Action |
|---|---|
| Left / A | Move lane left |
| Right / D | Move lane right |
| R | Restart after game-over |
| Esc | Quit |

## Core Systems

- 5-lane obstacle-dodge loop using Panda3D task updates.
- Difficulty ramp via decreasing spawn interval and faster obstacle speed.
- Collision checks using lane proximity and forward-distance threshold.
- Best score persistence to local JSON save file.
- Optional deterministic seed and run trace export to JSON.

## Technical Highlights

- Pure code-driven scene setup (no external model pipeline required).
- Deterministic reproducibility via `PANDA3D_SEED` environment variable.
- Debug trace output at `engines/panda3d/runtime/lane_drift_latest_run.json`.

## Performance Snapshot

See `engines/panda3d/PROFILING_BASELINE.md`.

## Release Operations

- Packaging script: `engines/panda3d/scripts/package-release.ps1`
- Quality gate: `engines/panda3d/scripts/quality-gate.ps1`
- Runbook: `engines/panda3d/RELEASE_RUNBOOK.md`

## Known Limitations

- No audio.
- No art asset pipeline beyond Panda3D built-in models.
- Trace export is single-file overwrite (latest run only).
