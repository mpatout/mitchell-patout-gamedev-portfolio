# Spark Catch — Solar2D

## Overview

Spark Catch is a mobile-first 2D arcade game built with Solar2D and Lua.
Catch safe sparks, avoid unstable shards, and use overcharge windows to
maximize score while surviving escalating spawn pressure.

The vertical slice is intentionally asset-light and code-heavy so reviewers can
evaluate systems design, gameplay tuning, and cross-engine adaptability.

## Minimum Version

Solar2D daily build 2025.3721 or newer.

## Quickstart

1. Install Solar2D: <https://solar2d.com/sdk>
2. Open Solar2D Simulator.
3. Select **File -> Open Project...** and choose `engines/solar2d`.
4. The simulator runs `main.lua` automatically.

## Controls

| Input | Effect |
| --- | --- |
| Drag player bar | Move catcher horizontally |
| Tap title / round-over prompt | Start or restart round |
| `P` key | Pause / resume |

## Core Systems

- Spawn budget controller that scales object frequency by level.
- Three drop types: safe spark, unstable shard, and overcharge token.
- Overcharge risk-reward mode: temporary score multiplier and faster spawn rate.
- Lives, score, combo streak, best-score persistence, and 75-second rounds.

## Technical Highlights

- Deterministic update loop using `enterFrame` delta-time progression.
- Table-backed object pool style lifecycle with explicit cleanup on despawn.
- Save data persistence through `system.DocumentsDirectory` JSON file.
- No external art/audio dependencies; all primitives are generated at runtime.

## Performance Snapshot

See [PROFILING_BASELINE.md](PROFILING_BASELINE.md).

## Acceptance Testing

Run and record checks in [ACCEPTANCE_TEST.md](ACCEPTANCE_TEST.md).

## Release Operations

- Packaging script: `engines/solar2d/scripts/package-release.ps1`
- Quality gate: `engines/solar2d/scripts/quality-gate.ps1`
- Full process: [RELEASE_RUNBOOK.md](RELEASE_RUNBOOK.md)

## Known Limitations

- No audio layer yet.
- Keyboard controls are development-only; mobile primary control is drag.
- Export to native mobile binaries is not scripted in this repo.
