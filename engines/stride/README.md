# Lane Surge - Stride (C# Baseline)

## Overview

Lane Surge is a Stride-oriented gameplay baseline implemented in C#.
It focuses on deterministic gameplay simulation, debug trace export, and release
quality workflows that align with the rest of the portfolio.

This baseline runs as a .NET simulation harness to keep execution lightweight
and reproducible in environments where the full Stride editor/runtime stack is
not installed.

## Quickstart

1. Install .NET SDK 8.0+.
2. From repo root, run:

```powershell
dotnet run --project engines/stride/src/LaneSurge/LaneSurge.csproj
```

3. Optional deterministic seed:

```powershell
$env:STRIDE_SEED="20260522"
dotnet run --project engines/stride/src/LaneSurge/LaneSurge.csproj
```

4. Output trace is written to:
`engines/stride/runtime/lane_surge_latest_run.json`.

## Controls

- This baseline is simulation-driven (no real-time controls yet).
- Input behavior is generated from deterministic/random lane decisions.

## Technical Highlights

- C# gameplay loop with lane-state collision checks and difficulty scaling.
- Deterministic seed mode (`STRIDE_SEED`) for reproducible traces.
- Local best-score persistence for repeatability checks.
- Portfolio-compatible acceptance, profiling, and release docs.

## Performance Snapshot

See `engines/stride/PROFILING_BASELINE.md`.

## Release Operations

- Packaging script: `engines/stride/scripts/package-release.ps1`
- Quality gate: `engines/stride/scripts/quality-gate.ps1`
- Runbook: `engines/stride/RELEASE_RUNBOOK.md`

## Known Limitations

- Not yet integrated with Stride editor scene/assets.
- No audio or animation systems in this baseline.
- No multiplayer/network features.
