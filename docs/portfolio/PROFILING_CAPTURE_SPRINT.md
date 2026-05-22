# Profiling Capture Sprint (One Pass)

Use this guide to clear all remaining profiling blockers in a single focused session.

## Goal

- Replace all `Pending` values in profiling baselines.
- Capture required low/high pressure screenshots for each active engine.
- Pass `scripts/check-profiling-readiness.ps1`.

## Sprint Order (Recommended)

1. Godot capture
2. Defold capture
3. Solar2D capture
4. Baseline doc updates
5. Gate check and commit

## Screenshot Targets

- Godot:
  - `docs/portfolio/evidence/profiling/godot/low-pressure.png`
  - `docs/portfolio/evidence/profiling/godot/high-pressure.png`
- Defold:
  - `docs/portfolio/evidence/profiling/defold/low-pressure.png`
  - `docs/portfolio/evidence/profiling/defold/high-pressure.png`
- Solar2D:
  - `docs/portfolio/evidence/profiling/solar2d/low-pressure.png`
  - `docs/portfolio/evidence/profiling/solar2d/high-pressure.png`

## Baseline Docs To Update

- `engines/Godot/PROFILING_BASELINE.md`
- `engines/defold/PROFILING_BASELINE.md`
- `engines/solar2d/PROFILING_BASELINE.md`

## Quick Command

From repository root:

```powershell
./scripts/run-profiling-capture-sprint.ps1 -OpenPaths
```

## Auto-Apply Captured Metrics

1. Copy template file:

```powershell
Copy-Item docs/portfolio/evidence/profiling/capture-data.template.json docs/portfolio/evidence/profiling/capture-data.json
```

2. Fill measured values in `capture-data.json`.
3. Apply values to all baseline docs:

```powershell
./scripts/apply-profiling-captures.ps1 -DataFile "docs/portfolio/evidence/profiling/capture-data.json" -ValidateScreenshots
```

After captures and doc updates:

```powershell
./scripts/check-profiling-readiness.ps1
./scripts/run-handshake-preflight.ps1
```
