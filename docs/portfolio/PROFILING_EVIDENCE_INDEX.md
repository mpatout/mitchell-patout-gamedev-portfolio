# Profiling Evidence Index

This index tracks concrete profiling artifacts for active engine slices.

## Required Evidence Per Engine

- Two screenshots:
  - low-pressure scenario
  - high-pressure scenario
- Updated capture log in each `PROFILING_BASELINE.md` with real values
- Short summary note of observed bottlenecks (or confirmation none were observed)

## Artifact Paths

| Engine | Screenshot Directory | Baseline Doc |
| --- | --- | --- |
| Godot | `docs/portfolio/evidence/profiling/godot/` | `engines/Godot/PROFILING_BASELINE.md` |
| Defold | `docs/portfolio/evidence/profiling/defold/` | `engines/defold/PROFILING_BASELINE.md` |
| Solar2D | `docs/portfolio/evidence/profiling/solar2d/` | `engines/solar2d/PROFILING_BASELINE.md` |

## Suggested Filenames

- `low-pressure.png`
- `high-pressure.png`

## Ready-To-Submit Gate

From repository root, run:

```powershell
./scripts/check-profiling-readiness.ps1
```

The check passes only when no `Pending` values remain in baseline docs and all required screenshots are present.

For a one-pass capture workflow, use `docs/portfolio/PROFILING_CAPTURE_SPRINT.md`
and `scripts/run-profiling-capture-sprint.ps1`.
